const axios = require('axios');

document.addEventListener("turbolinks:load", function() {
  const csrfToken = document.querySelector("meta[name=csrf-token]").content;
  axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;
  document.getElementById('vouchedContainer') && mountVouched()
})

const mountVouched = () => {
  var vouched = Vouched({
      appId: 'fLL6wNS@6~s8K2mPk7tm#s_m!sREz#',
      types: ['id-verification'],
      content: {
        success: 'Thank you for updating your information. We will review and get back to you.',
        review:
          'Thank you for updating your information. We will review and get back to you.',
        verifyPass:
          'Everything looks good to us. Click next to submit information.',
        verifyFail:
          "We couldn't verify you. You will need to try it again."
      },
      theme: {
        baseColor: '#F98685',
        bgColor: '#FFF'
      },
      onDone: (job) => {
          axios.post(`/identification/`, {
            data: job,
          }).then( (response) => {
             window.location.href = response.request.responseURL
          });
      }
  })
  vouched.mount('#vouchedContainer')
}
