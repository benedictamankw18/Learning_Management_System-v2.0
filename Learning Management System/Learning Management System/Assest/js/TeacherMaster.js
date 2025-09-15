// Sticky nav on scroll
const nav = document.getElementById("nav");
const navOffset = nav.offsetTop;

window.addEventListener("scroll", function () {
    if (window.pageYOffset >= navOffset) {
        nav.classList.add("sticky-nav");
    } else {
        nav.classList.remove("sticky-nav");
    }
});