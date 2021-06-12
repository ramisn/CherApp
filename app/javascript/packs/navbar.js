
document.addEventListener("turbolinks:load", function() {
  const menuItem = document.querySelector('.menu-button');
  menuItem && menuItem.addEventListener('click', handleMenuClick);
});

const handleMenuClick = button => {
  const navMenu = document.querySelector('.nav-menu ul');
  if (navMenu.classList.contains('hide') || navMenu.classList.length == 0) {
    navMenu.classList.remove('hide');
    navMenu.classList.add('show');
  } else {
    navMenu.classList.remove('show');
    navMenu.classList.add('hide');
  }

}
