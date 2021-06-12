import { Controller } from 'stimulus';
import bulmaCarousel from 'bulma-carousel/dist/js/bulma-carousel.min.js';

export default class extends Controller {
  static targets = ['imageContainer', 'galleryContainer', 'images']

  connect = () => {
    const options = {
                      initialSlide: 0,
                      slidesToScroll: 1,
                      slidesToShow: 1,
                      loop: true,
                    };
      bulmaCarousel.attach('.carousel', options);
  }
}
