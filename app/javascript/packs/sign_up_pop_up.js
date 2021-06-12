document.addEventListener('turbolinks:load', () => {
  const modal = document.getElementById('autoPopUpModal');
  if (modal) {
    setTimeout(() => {
      document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
      modal.classList.add('is-active');
    }, 10000);
  }
});
