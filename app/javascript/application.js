// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

// ⚡ Global Lucide Icons Initializer
const initLucide = () => {
  if (window.lucide && typeof window.lucide.createIcons === "function") {
    window.lucide.createIcons()
  }
}

// ⚡ Global Toast Notification Auto-Dismiss & Manual Dismiss Handler
window.dismissToast = (id) => {
  const toast = document.getElementById(id)
  if (toast) {
    toast.classList.add("animate-toast-out")
    setTimeout(() => {
      if (toast.parentElement) toast.remove()
    }, 300)
  }
}

document.addEventListener("DOMContentLoaded", initLucide)
document.addEventListener("turbo:load", initLucide)
document.addEventListener("turbo:frame-render", initLucide)
