const onboardingHelpers = {
  submitBusiness(callback) {
    const type = store.get('business').id ? 'PATCH' : 'POST';
    $.ajax({
      url: type === 'PATCH' ? `/onboard/businesses/${store.get('business').id}` : '/onboard/businesses',
      dataType: 'json',
      type,
      data: {
        business: store.get('business')
      },
      success: callback,
      error: (res) => console.log(res),
    });
  }
}
