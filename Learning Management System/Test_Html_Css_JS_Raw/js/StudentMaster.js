const searchOpen = document.getElementById('search-open');
searchOpen.addEventListener('click', () =>{
    const activatedSearchOff = document.querySelectorAll('.activated-search-off');
// activated-search
    const searchBar = document.getElementById('search-bar');
    searchBar.classList.toggle('activated-search')
    activatedSearchOff.forEach(item => item.style.display = "flex"   )
    // alert("HELLO WORLD");
    searchOpen.style.display = "none";
});

const searchClose = document.getElementById('close-search');
searchClose.addEventListener('click', () =>{
    const activatedSearchOff = document.querySelectorAll('.activated-search-off');
    const searchBar = document.getElementById('search-bar');
    searchBar.classList.remove('activated-search')
    activatedSearchOff.forEach(item => item.style.display = "none"   )
    searchClose.style.display = "none";
    searchOpen.style.display = "flex";
});


      // Sticky nav on scroll
      const nav = document.getElementById("header");
      const navOffset = nav.offsetTop;

      window.addEventListener("scroll", function () {
        if (window.pageYOffset >= navOffset) {
          nav.classList.add("sticky-nav");
        } else {
          nav.classList.remove("sticky-nav");
        }
      });