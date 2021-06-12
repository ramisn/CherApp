import { Controller } from 'stimulus';
import defaultPoropertyImage from '../../assets/images/cherapp-ownership-coborrowing-property_placeholder.png';

export default class extends Controller {
  setDefaultPropertyImage = (event) => {
    event.stopPropagation();
    event.preventDefault();
    event.target.setAttribute('src', defaultPoropertyImage);
  }
}
