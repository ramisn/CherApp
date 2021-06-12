/* eslint-disable prefer-destructuring */
function checkVisibility(elements) {
  elements.forEach((el) => {
    const rect = el.getBoundingClientRect();
    if (rect.top < window.innerHeight - 50) {
      el.classList.add('visible');
    }
  });
}

document.addEventListener('turbolinks:load', () => {
  const animatedElements = document.querySelectorAll('.view-animation');
  const videoPlayPause = document.querySelector('.playVideo');
  const videoPlayer = document.querySelector('#video');
  const viewMoreElements = document.querySelectorAll('.view-more');

  checkVisibility(animatedElements);

  document.addEventListener('scroll', () => {
    checkVisibility(animatedElements);
  });

  if (videoPlayPause) {
    videoPlayPause.addEventListener('click', () => {
      videoPlayer.play();
      videoPlayer.classList.toggle('playing');
      videoPlayPause.classList.add('is-hidden');
    });
  }

  if (videoPlayer) {
    videoPlayer.addEventListener('click', () => {
      videoPlayer.pause();
      videoPlayer.classList.toggle('playing');
      videoPlayPause.classList.remove('is-hidden');
    });
  }

  if (viewMoreElements) {
    viewMoreElements.forEach((element) => {
      element.addEventListener('click', (event) => {
        const elementToShow = event.target.closest('.info-section');
        const elemenentToHide = document.querySelectorAll('.info-section');
        if (elementToShow.classList.contains('show-information')) {
          elemenentToHide.forEach((section) => section.classList.remove('hide-information'));
          elementToShow.classList.remove('show-information');
        } else {
          elemenentToHide.forEach((section) => section.classList.add('hide-information'));
          elementToShow.classList.add('show-information');
          elementToShow.classList.remove('hide-information');
        }
      });
    });
  }
});
