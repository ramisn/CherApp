import { Controller } from 'stimulus';
import axios from '../packs/axios_utils.js';

export default class extends Controller {
  updateNotificationStatus() {
    const notificationId = this.data.get('notification-id');
    axios.put(`/notifications/${notificationId}`, { notification: { status: 'readed' } });
  }
}
