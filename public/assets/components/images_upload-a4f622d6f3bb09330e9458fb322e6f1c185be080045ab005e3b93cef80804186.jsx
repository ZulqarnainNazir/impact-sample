(function() {
  var ImagesUpload;

  ImagesUpload = React.createClass({
    propTypes: {
      presignedPost: React.PropTypes.object.isRequired
    },
    getInitialState: function() {
      return {
        uploading: false,
        uploads: []
      };
    },
    componentDidMount: function() {
      return $(this.getDOMNode()).fileupload({
        dataType: 'XML',
        url: this.props.presignedPost.url,
        formData: this.props.presignedPost.fields,
        paramName: 'file',
        dropZone: '.images-upload-dropzone',
        start: this.uploadStart,
        add: this.uploadAdd,
        progress: this.uploadProgress,
        done: this.uploadDone,
        fail: this.uploadFail
      });
    },
    render: function() {
      return <div>
      {this.renderForm()}
      {this.renderUploads()}
    </div>;
    },
    renderForm: function() {
      if (!this.state.uploading) {
        return <div>
        <input type="file" className="hidden" ref="fileInput" multiple />
        <div className="row">
          <div className="col-sm-4 col-sm-offset-4">
            <div onClick={this.triggerFileInput} className="btn btn-block btn-primary" style={{marginRight: 20}}><i className="fa fa-plus-circle"></i> Choose Images</div>
          </div>
        </div>
        <div className="images-upload-dropzone text-muted text-center" style={{border: 'dashed 1px #bbb', borderRadius: 2, fontSize: 18, margin: '40px 0', padding: '40px 20px'}}>Or drop images here to begin bulk upload.</div>
      </div>;
      }
    },
    renderUploads: function() {
      if (this.state.uploading) {
        return this.state.uploads.map(this.renderUpload);
      }
    },
    renderUpload: function(upload) {
      return <div key={upload.key} style={{marginTop: 20, marginBottom: 20}}>
      <div>
        <div className="small clearfix">
          <strong>{upload.file_name}</strong> <span className="pull-right">{upload.file_size / 1000}kb</span>
        </div>
        {this.renderProgress(upload)}
        {this.renderStatus(upload)}
      </div>
    </div>;
    },
    renderProgress: function(upload) {
      return <div className="progress" style={{marginTop: 5, marginBottom: 5}}>
      {this.renderProgressBar(upload)}
    </div>;
    },
    renderProgressBar: function(upload) {
      if (upload.status === 'uploading') {
        return <div className="progress-bar progress-bar-striped active" style={{width: this.progressWidthPercentage(upload.progress)}} />;
      } else if (upload.status === 'finishing') {
        return <div className="progress-bar progress-bar-striped progress-bar-success active" style={{width: '100%'}} />;
      } else if (upload.status === 'attached') {
        return <div className="progress-bar progress-bar-success" style={{width: '100%'}} />;
      } else if (upload.status === 'failed') {
        return <div className="progress-bar progress-bar-danger" style={{width: '100%'}} />;
      }
    },
    renderStatus: function(upload) {
      if (upload.status === 'uploading') {
        return <div className="small text-muted">Uploading...</div>;
      } else if (upload.status === 'finishing') {
        return <div className="small text-muted">Saving...</div>;
      } else if (upload.status === 'attached') {
        return <div className="small text-success">Saved.</div>;
      } else if (upload.status === 'failed') {
        return <div className="small text-danger">Failed to upload image.</div>;
      }
    },
    uploadStart: function() {
      return this.setState({
        uploading: true
      });
    },
    uploadAdd: function(event, data) {
      var file, formData, key, upload;
      key = 'upload-' + parseInt(Math.random() * Math.pow(10, 12));
      file = data.files[0];
      file.key = key;
      formData = this.props.presignedPost.fields;
      formData['Content-Type'] = file.type;
      data.formData = formData;
      data.submit();
      upload = {
        content_type: file.type,
        file_name: file.name,
        file_size: file.size,
        key: key,
        progress: 0,
        status: 'uploading'
      };
      return this.setState({
        uploads: React.addons.update(this.state.uploads, {
          $push: [upload]
        })
      });
    },
    uploadProgress: function(event, data) {
      var existingUpload, filter, index, newUpload, progress;
      filter = function(u) {
        return u.key === data.files[0].key;
      };
      existingUpload = this.state.uploads.filter(filter)[0];
      if (existingUpload) {
        index = this.state.uploads.indexOf(existingUpload);
        progress = parseInt(data.loaded / data.total);
        newUpload = $.extend(existingUpload, {
          progress: progress
        });
        return this.setState({
          uploads: React.addons.update(this.state.uploads, {
            $splice: [[index, 1, newUpload]]
          })
        });
      }
    },
    uploadDone: function(event, data) {
      var existingUpload, filter, index, newUpload, url, urlKey;
      filter = function(u) {
        return u.key === data.files[0].key;
      };
      existingUpload = this.state.uploads.filter(filter)[0];
      if (existingUpload) {
        index = this.state.uploads.indexOf(existingUpload);
        urlKey = $(data.jqXHR.responseXML).find('Key').text();
        url = "//" + this.props.presignedPost.host + "/" + urlKey;
        newUpload = $.extend(existingUpload, {
          status: 'finishing',
          url: url
        });
        return this.setState({
          uploads: React.addons.update(this.state.uploads, {
            $splice: [[index, 1, newUpload]]
          })
        }, this.uploadTransfer.bind(null, data.files[0].key));
      }
    },
    uploadTransfer: function(key) {
      var aJ, existingUpload, filter, image_data;
      filter = function(u) {
        return u.key === key;
      };
      existingUpload = this.state.uploads.filter(filter)[0];
      if (existingUpload) {
        image_data = {
          attachment_cache_url: existingUpload.url,
          attachment_content_type: existingUpload.content_type,
          attachment_file_size: existingUpload.file_size,
          attachment_file_size: existingUpload.file_size
        };
        aJ = $.ajax({
          type: 'POST',
          url: this.props.uploadURL,
          beforeSend: function(xhr) {
            return xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'));
          },
          cache: false,
          data: {
            image: image_data
          },
          dataType: 'html'
        });
        aJ.done(this.uploadFinish.bind(null, key));
        return aJ.fail(this.uploadFail.bind(null, null, {
          files: [
            {
              key: key
            }
          ]
        }));
      }
    },
    uploadFinish: function(key) {
      var existingUpload, filter, index, newUpload;
      filter = function(u) {
        return u.key === key;
      };
      existingUpload = this.state.uploads.filter(filter)[0];
      if (existingUpload) {
        index = this.state.uploads.indexOf(existingUpload);
        newUpload = $.extend(existingUpload, {
          status: 'attached'
        });
        return this.setState({
          uploads: React.addons.update(this.state.uploads, {
            $splice: [[index, 1, newUpload]]
          })
        });
      }
    },
    uploadFail: function(event, data) {
      var existingUpload, filter, index, newUpload;
      filter = function(u) {
        return u.key === data.files[0].key;
      };
      existingUpload = this.state.uploads.filter(filter)[0];
      if (existingUpload) {
        index = this.state.uploads.indexOf(existingUpload);
        newUpload = $.extend(existingUpload, {
          status: 'failed'
        });
        return this.setState({
          uploads: React.addons.update(this.state.uploads, {
            $splice: [[index, 1, newUpload]]
          })
        });
      }
    },
    progressWidthPercentage: function(progress) {
      return progress + '%';
    },
    triggerFileInput: function() {
      return $(this.refs.fileInput.getDOMNode()).click();
    }
  });

  window.ImagesUpload = ImagesUpload;

}).call(this);
