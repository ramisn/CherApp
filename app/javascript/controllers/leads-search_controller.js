import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = ['search_by', 'keyword']

  connect() {
    // this.phoneNumberTarget.addEventListener('keydown', (event) => {
    //   const keyPressed = event.key;
    //   if (!keyPressed.match(/\d|Backspace|ArrowLeft|ArrowRight/)) {
    //     event.preventDefault();
    //     event.stopPropagation();
    //   }
    // });
  }

  processResponse(response) {
    const [data, _status, _xhr] = response.detail;
    this.requestMessageTarget.innerHTML = data;
  }

  mapOnLoading() {
    console.log('mapOnLoading called...');
  }


  processPropertiesResponse(response) {
    const [data, _status, xhr] = response.detail;
    const searchKeyword = this.keyword.value;
    console.log('processPropertiesResponse', data)
    // const { properties, notice } = data;
    // if (xhr.status === 200 && properties.length) {
    //   this.populatePropertiesContainer(data.html);
    // }
    // this.requestResponseTarget.innerHTML = notice;
  }
}
