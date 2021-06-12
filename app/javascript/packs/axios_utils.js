import axios from 'axios';

const csrfTokenTag = document.querySelector('meta[name=csrf-token]');
const csrfToken = csrfTokenTag ? csrfTokenTag.content : '';
export default axios.create({
  headers: {
    Accept: 'application/json',
    'X-CSRF-Token': csrfToken,
  },
});
