import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'lastRespondedQuestion', 'container', 'statusBar', 'carouselContainer']

  initialize(){
    let lastRespondedQuestionContainerName = this.lastRespondedQuestionTarget.value || 'liveFactor0'
    let questionContainer = document.getElementById(lastRespondedQuestionContainerName);
    let index = questionContainer.getAttribute("data-index");
    document.getElementById('progressBar').setAttribute("value", index);
    this.showItem(questionContainer);
    this.initializeStepper(lastRespondedQuestionContainerName);
    this.data.inProgress = false;
  }

  decreaseBar(){
    let progress = parseInt(this.statusBarTarget.getAttribute('value'));
    this.statusBarTarget.setAttribute('value', progress - 1);
  }

  fadeItem(item) {
    item.classList.add('fade-carousel');
    setTimeout(() => {
      item.classList.remove('is-active');
      item.classList.remove('fade-carousel');
    }, 500);
  }

  hideContainers(){
    let carouselItems = document.querySelectorAll(".carousel-item");
    carouselItems.forEach((item) => {
      item.classList.contains('is-active') && this.fadeItem(item);
    })
  }

  increaseBar(){
    let progress = parseInt(this.statusBarTarget.getAttribute('value'));
    this.statusBarTarget.setAttribute('value', progress + 1);
  }

  initializeStepper(lastRespondedQuestionContainerName){
    let containersIds = [];
    this.containerTargets.forEach(container => {
      containersIds.push(container.getAttribute("id"))
    });
    let indexToSplit = containersIds.indexOf(lastRespondedQuestionContainerName);
    this.data.backContainers = containersIds.slice(0, indexToSplit);
    this.data.nextContainers = containersIds.slice(indexToSplit + 1);
    this.data.currentContainer = lastRespondedQuestionContainerName;
  }

  nextElement(event){
    const nextElementId = this.data.nextContainers.shift();
    if(nextElementId && !this.data.inProgress){
      this.hideContainers();
      const nextElement = document.getElementById(nextElementId);
      this.showItem(nextElement);
      const currentElement = event.target.getAttribute("data-current");
      this.data.backContainers.push(currentElement);
      this.data.currentContainer = nextElementId;
      this.updateLastRespondedQuestionValue(event.target);
      this.increaseBar();
      !this.data.nextContainers.length && this.hideFullTest();
    }
  }

  hideFullTest(){
    const container = this.carouselContainerTarget;
    container.classList.add('is-hiden');
  }

  previousElement(event) {
    let previousElementId = this.data.backContainers.pop();
    if(previousElementId && !this.data.inProgress){
      this.hideContainers();
      this.data.nextContainers.unshift(this.data.currentContainer);
      this.data.currentContainer = previousElementId;
      let previousElement = document.getElementById(previousElementId);
      this.showItem(previousElement);
      this.updateLastRespondedQuestionValue(event.target);
      this.decreaseBar();
    }
  }

  showItem(item) {
    this.data.inProgress = true;
    setTimeout(() => {
      item.classList.add("is-active");
      this.data.inProgress = false;
    }, 500);
  }

  updateLastRespondedQuestionValue() {
    this.lastRespondedQuestionTarget.value = this.data.currentContainer;
  }
}
