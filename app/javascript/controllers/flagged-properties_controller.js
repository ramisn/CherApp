import { Controller } from "stimulus"
import axios from '../packs/axios_utils.js';


export default class extends Controller {
  initialize() {
    this.fetchFlaggedProperties();
  }

  fetchFlaggedProperties() {
    const flaggedProperiesContainer = document.querySelector(".flagged-properties")
    axios.get('/flagged_properties', { headers: { 'Accept': 'html/text' } }).
      then(response =>  flaggedProperiesContainer.innerHTML = response.data)
  }
}
