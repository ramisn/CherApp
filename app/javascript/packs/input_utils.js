export default function updateInpuntHeight(input) {
  setTimeout(() => {
    input.style.cssText = 'height:auto; padding:0';
    input.style.cssText = '-moz-box-sizing:content-box';
    input.style.cssText = `height: ${input.scrollHeight}px`;
  }, 0);
}
