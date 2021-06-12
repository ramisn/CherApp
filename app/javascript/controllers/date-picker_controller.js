import { Controller } from 'stimulus';
import bulmaCalendar from 'bulma-calendar/dist/js/bulma-calendar.min.js';

export default class extends Controller {
  static targets = ['picker']

  connect = () => {
    const today = new Date();
    const { isDateRestricted, isRequired } = this.pickerTarget.dataset;

    const dateOptions = {
                      type: 'date',
                      minDate: isDateRestricted ? today : null,
                      showFooter: false,
                      showHeader: false,
                      dateFormat: 'MM/DD/YYYY',
                    };

    bulmaCalendar.attach('[type="date"]', dateOptions);

    if (isRequired) {
      const [input] = document.getElementsByClassName('datetimepicker-dummy-input');

      input.removeAttribute('readonly');
      input.required = true;

      input.addEventListener('keydown', (e) => { e.preventDefault(); });
    }
  }
}
