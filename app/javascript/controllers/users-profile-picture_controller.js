import { Controller } from 'stimulus';
import defaultProfilePicture from '../../assets/images/cherapp-ownership-coborrowing-ico-user.svg';

export default class extends Controller {
  setDefaultPicture = (event) => {
    event.preventDefault();
    event.stopPropagation();
    event.target.setAttribute('src', defaultProfilePicture);
  }
}
