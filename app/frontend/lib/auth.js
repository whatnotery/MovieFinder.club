import axios from 'axios'

export let csrfToken = document.querySelector('meta[name=csrf-token]').content;
axios.defaults.headers.common['X-CSRF-Token'] = csrfToken;