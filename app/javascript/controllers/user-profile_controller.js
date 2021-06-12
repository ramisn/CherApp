import { Controller } from 'stimulus';

export default class extends Controller {
  static targets = [
                    'professionalOptionContainer', 'agentRadio',
                    'professionalAgreementInput', 'professionalRoleInput',
                    'professionalEstateAgentContainer', 'submitButton',
                    ]

  toggleProfessionalRequirements() {
    const userIsProfessional = this.agentRadioTarget.checked;
    this.professionalRoleInputTarget.required = userIsProfessional;
    this.professionalOptionContainerTarget.classList.toggle('is-hidden', !userIsProfessional);
    this.submitButtonTarget.classList.remove('is-secondary');
    this.submitButtonTarget.classList.add('is-primary');
    if (!userIsProfessional) {
      this.resetProfessionalOptions();
    }
  }

  requireEstateAgentAgreement() {
    const professionalRole = this.professionalRoleInputTarget.value;
    const isEstateAgentSelected = professionalRole === 'estate_agent';
    this.professionalEstateAgentContainerTarget.classList.toggle('is-hidden', !isEstateAgentSelected);
    this.professionalAgreementInputTarget.required = isEstateAgentSelected;
  }

  resetProfessionalOptions() {
    this.professionalRoleInputTarget.selectedIndex = 0;
    this.professionalAgreementInputTarget.checked = false;
    this.professionalEstateAgentContainerTarget.classList.add('is-hidden');
  }
}
