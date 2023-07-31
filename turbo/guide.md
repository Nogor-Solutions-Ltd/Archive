# Turbo Js

### Reference
``` https://turbo.hotwired.dev/reference/drive ```

### How to use

``` Include it in master layout, That's all. ```
```javascript
<script type="module">
       import hotwiredTurbo from 'https://cdn.skypack.dev/@hotwired/turbo';
</script>
```

### Write you JS
```javascript
document.addEventListener(`turbo:load`, () => {
    // Code Here...
})
```

### Loading Spinner
Before fetching any content it will show spinner.

``` In style ```
```css
<style>
  #loader-overlay {
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: rgba(0, 0, 0, 0.5);
      z-index: 9999;
  }

  .spinner {
      width: 40px;
      height: 40px;
      border: 4px solid #f3f3f3;
      border-top: 4px solid #3498db;
      border-radius: 50%;
      animation: spin 2s linear infinite;
  }

  @keyframes spin {
      0% {
          transform: rotate(0deg);
      }

      100% {
          transform: rotate(360deg);
      }
  }
<style>
```
``` In blade content ```
```html
<div id="loader-overlay" style="display:none;">
    <div class="spinner"></div>
</div>
```

``` In javascript ```
```javacscript

document.addEventListener('turbo:before-fetch-request', function() {
    let loaderOverlay = document.getElementById('loader-overlay');
    loaderOverlay.style.display = 'flex';
});

document.addEventListener('turbo:render', function() {
    let loaderOverlay = document.getElementById('loader-overlay');
    loaderOverlay.style.display = 'none';
});
```

### Scroll Issue

In Firefox there is some issues with scroll, to fix that you should include these code in you ``` master.blade.php ``` file.

```javacscript
document.addEventListener(`turbo:load`, () => {
    document.documentElement.style.scrollBehavior = `smooth`
})

document.addEventListener(`turbo:before-visit`, () => {
    document.documentElement.style.scrollBehavior = `unset`
})

document.addEventListener('turbo:before-fetch-request', function() {
    window.scrollTo(0, 0);
});
```
