const menuItems = document.querySelectorAll('.menu-item');
window.addEventListener('load',() => {
    menuItems.forEach(i => i.classList.remove('active'));
   document.querySelector('.side-menu a:first-child').classList.toggle('active');
});

document.addEventListener('DOMContentLoaded', function() {
  const sidebar = document.getElementById('sidebar');
  const toggleButton = document.querySelector('.mobile-menu-toggle');

  toggleButton.addEventListener('click', function() {

    if (sidebar.style.width === '65px' || sidebar.style.width === '') {
      sidebar.style.width = '250px';
    document.querySelector('.mobile-menu-toggle i').classList.remove('fa-bars');
    document.querySelector('.mobile-menu-toggle i').classList.toggle('fa-close');
    } else {
      sidebar.style.width = '65px';
    document.querySelector('.mobile-menu-toggle i').classList.toggle('fa-bars');
    document.querySelector('.mobile-menu-toggle i').classList.remove('fa-close');
    }

  });

  // Add event listener for the menu items
  menuItems.forEach(item => {
    item.addEventListener('click', function() {
      menuItems.forEach(i => i.classList.remove('active'));
      this.classList.add('active');
    });
  });
});