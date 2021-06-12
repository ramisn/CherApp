document.addEventListener('turbolinks:load', () => {
  const environment = document.querySelector('body').getAttribute('data-environment');
  if (environment === 'production') {
    fbq('track', 'PageView');
    gtag('config', 'UA-154644142-1', {
      page_title: window.title,
      page_path: window.location.pathname,
    });
  }
});
