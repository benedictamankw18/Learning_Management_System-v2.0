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






//Load page 

// function loadDashboard() {
//   fetch('dash.html')
//       .then(response => response.text())
//       .then(html => {
//           // Extract only the dashboard content (between body tags)
//           const parser = new DOMParser();
//           const doc = parser.parseFromString(html, 'text/html');
//           const dashboardContent = doc.querySelector('.dashboard');
          
//           if (dashboardContent) {
//               document.getElementById('main-content').innerHTML = dashboardContent.outerHTML;
//               // Reinitialize charts after content is loaded
//               initializeCharts();
//           }
//       })
//       .catch(error => {
//           console.error('Error loading dashboard:', error);
//           document.getElementById('main-content').innerHTML = '<h2>Error loading dashboard</h2>';
//       });
// }

function User(){
  fetch('User.html')
    .then(response => response.text())
    .then(html => {
      // Extract only the dashboard content (between body tags)
          const parser = new DOMParser();
          const doc = parser.parseFromString(html, 'text/html');
          const userContent = doc.querySelector('.user');
          
          if (userContent) {
              document.getElementById('main-content').innerHTML = userContent.outerHTML;
              // Reinitialize charts after content is loaded
              // initializeCharts();
          }
      })
      .catch(error => {
          console.error('Error loading dashboard:', error);
          document.getElementById('main-content').innerHTML = '<h2>Error loading dashboard</h2>';
    });
}