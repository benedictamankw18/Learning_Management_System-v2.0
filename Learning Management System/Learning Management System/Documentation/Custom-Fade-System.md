# Custom Fade Animation System

This document explains how to use the custom fade animation system that replaces Bootstrap's fade functionality in the Learning Management System.

## Overview

The custom fade system provides smooth, performant animations for modals, tabs, and other UI elements while maintaining compatibility with existing Bootstrap JavaScript functionality.

## Files Included

1. **AdminMaster.css** - Contains all CSS animations and transitions
2. **custom-animations.js** - JavaScript handler for modal and tab animations
3. **Updated page files** - Pages with `custom-fade` classes instead of Bootstrap `fade`

## CSS Classes

### Modal Animations
```css
.custom-fade              /* Base fade class for modals */
.modal.custom-fade        /* Modal-specific fade animations */
.modal-backdrop.custom-fade /* Backdrop fade animations */
```

### Tab Animations
```css
.tab-pane.custom-fade     /* Tab pane fade animations */
.tab-pane.slide-fade      /* Alternative slide + fade effect */
```

### Card Animations
```css
.card-animate             /* Basic card animation */
.stagger-animate          /* Staggered animation timing */
```

### Utility Classes
```css
.fade-in                  /* Simple fade in animation */
.fade-out                 /* Simple fade out animation */
.slide-up                 /* Slide up animation */
.slide-down               /* Slide down animation */
.loading-fade             /* Loading state animation */
```

## HTML Implementation

### Modals
Replace Bootstrap fade classes:
```html
<!-- OLD Bootstrap way -->
<div class="modal fade" id="myModal">

<!-- NEW Custom way -->
<div class="modal custom-fade" id="myModal">
```

### Tab Panes
Replace Bootstrap fade classes:
```html
<!-- OLD Bootstrap way -->
<div class="tab-pane fade show active" id="tab1">

<!-- NEW Custom way -->
<div class="tab-pane custom-fade show active" id="tab1">
```

### Cards with Animation
Add animation classes to cards:
```html
<div class="card card-animate stagger-animate">
    <!-- Card content -->
</div>
```

## JavaScript API

The custom animation system provides a global `CustomAnimations` object:

### Modal Control
```javascript
// Show a modal
CustomAnimations.showModal('myModal');

// Hide a modal
CustomAnimations.hideModal('myModal');
```

### Tab Control
```javascript
// Show a specific tab
CustomAnimations.showTab('tab1');
```

### Animation Control
```javascript
// Trigger animations on new elements
CustomAnimations.animateElements();

// Show loading state
CustomAnimations.showLoading(element);

// Hide loading state
CustomAnimations.hideLoading(element);
```

### Event Listeners
The system provides custom events:

```javascript
// Listen for modal events
document.addEventListener('shown.custom.modal', function(e) {
    console.log('Modal shown:', e.target);
});

document.addEventListener('hidden.custom.modal', function(e) {
    console.log('Modal hidden:', e.target);
});

// Listen for tab events
document.addEventListener('shown.custom.tab', function(e) {
    console.log('Tab shown:', e.target);
});
```

## Migration Guide

### Step 1: Update HTML Classes
Replace all instances of:
- `class="modal fade"` → `class="modal custom-fade"`
- `class="tab-pane fade"` → `class="tab-pane custom-fade"`

### Step 2: Include JavaScript File
Add to your page header:
```html
<script src="../../Assest/js/custom-animations.js"></script>
```

### Step 3: Update Event Listeners (if needed)
Replace Bootstrap modal events with custom events:
```javascript
// OLD
$('#myModal').on('shown.bs.modal', function() { ... });

// NEW
document.addEventListener('shown.custom.modal', function(e) {
    if (e.target.id === 'myModal') { ... }
});
```

## Features

### Performance Benefits
- Hardware-accelerated CSS transitions
- Optimized animation timing
- Reduced JavaScript overhead
- Better mobile performance

### Animation Features
- Smooth fade in/out
- Scale animations for modals
- Slide animations for tabs
- Staggered animations for multiple elements
- Loading state animations

### Browser Compatibility
- Modern browsers (Chrome, Firefox, Safari, Edge)
- Fallback for older browsers
- Mobile-optimized

## Customization

### Timing
Modify animation duration in CSS:
```css
.custom-fade {
    transition: opacity 0.3s ease-in-out; /* Change 0.3s to desired duration */
}
```

### Easing
Change animation easing:
```css
.custom-fade {
    transition: opacity 0.3s cubic-bezier(0.4, 0, 0.2, 1); /* Custom easing */
}
```

### Custom Animations
Add new animation classes:
```css
.my-custom-animation {
    opacity: 0;
    transform: translateX(20px);
    transition: all 0.4s ease-in-out;
}

.my-custom-animation.show {
    opacity: 1;
    transform: translateX(0);
}
```

## Troubleshooting

### Common Issues

1. **Modals not showing**
   - Ensure `custom-animations.js` is loaded
   - Check console for JavaScript errors
   - Verify modal has `custom-fade` class

2. **Animations not smooth**
   - Check CSS transitions are properly defined
   - Ensure no conflicting CSS
   - Test on different browsers

3. **Events not firing**
   - Use custom events instead of Bootstrap events
   - Check event listener timing
   - Verify DOM elements exist

### Debug Mode
Enable debug logging:
```javascript
// Add to your page
window.CustomAnimationsDebug = true;
```

## Examples

See the following pages for implementation examples:
- `User.aspx` - Complete implementation with modals and tabs
- `AdminMaster.css` - All animation styles
- `custom-animations.js` - JavaScript implementation

## Support

For issues or questions about the custom animation system, check:
1. Console logs for JavaScript errors
2. CSS validation for styling issues
3. Browser developer tools for performance analysis
