import React from 'react';
import ReactDOM from 'react-dom';
import PropTypes from 'prop-types';
import FontAwesome from 'react-fontawesome';
import axios from '../packs/axios_utils.js';
import plusIcon from '../../assets/images/cherapp-ownership-coborrowing-ico-plus.svg';


const UserGalleryUpload = ({
 triggerInput, isUploading, imageInput, addImageToGalery, user,
}) => {
  const isAgent = user.role === 'agent';

  return ReactDOM.createPortal((
    !isAgent &&
    (<button type="button" onClick={triggerInput} className={`button ${ isUploading ? 'is-loading' : '' } ${ isAgent ? 'is-mint' : 'is-secondary' }`}>
      <img src={plusIcon} alt="Plus icon" className={isUploading ? 'is-hidden' : ''} />
      <input
        ref={imageInput}
        type="file"
        className="is-hidden"
        accept="image/png, image/jpeg, image/jpg"
        onChange={addImageToGalery}
      />
    </button>)
  ), document.getElementById('profileAvatarImage'));
};

class UserGallery extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      user: props.user,
    };
    this.imageInput = React.createRef();
  }

  componentDidMount() {
    const modalContent = document.getElementById('modalContent');
    const galleryModal = document.getElementById('imageModalContainer');
    document.addEventListener('click', (event) => {
      const isClickInsideImage = modalContent.contains(event.target);
      const isClickInsideModal = galleryModal.contains(event.target);
      const { isModalActive } = this.state;
      if (isClickInsideModal && !isClickInsideImage && isModalActive) {
        this.closeModal();
      }
    });
  }

  addImageToGalery = (event) => {
    const image = event.target.files[0];
    const fileSize = image.size / 1024;
    if (fileSize > 10240) {
      alert('Only images less than 10MB are permited');
    } else {
      this.setState({ isUploading: true });
      const formData = new FormData();
      formData.append('user[image]', image);
      axios.post('/user_images', formData, { headers: { 'Content-Type': image.type } })
      .then((response) => {
        if (response.status === 200) {
          this.setState({
            user: response.data,
            isUploading: false,
            });
        }
      });
    }
    this.imageInput.current.value = '';
  }

  triggerInput = () => {
    this.imageInput.current.click();
  }

  removeImage = (event) => {
    event.preventDefault();
    event.stopPropagation();
    const imageId = event.target.dataset.value;
    axios.delete(`/user_images/${imageId}`)
    .then((response) => {
      this.setState({ user: response.data });
    });
  }

  activateModal = (event) => {
    event.stopPropagation();
    event.preventDefault();
    const modalSrc = event.target.dataset.src;
    this.setState({
      modalSrc,
      isModalActive: true,
    });
    document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
  }

  closeModal = () => {
    this.setState({
      modalSrc: null,
      isModalActive: false,
    });
    document.getElementsByTagName('html')[0].classList.toggle('is-clipped');
  }

  render() {
    const {
            user,
            isModalActive,
            modalSrc,
            isUploading,
          } = this.state;
    const { images } = user;
    const { isEditable } = this.props;

    return (
      <div className="gallery-container">
        {images.map((image) => (
          <button
            type="button"
            key={image.id}
            className="gallery-image-container"
            data-src={image.url}
            onClick={this.activateModal}
          >
            <img src={image.url} className="gallery-image" alt="User galery" />
            {isEditable && (
              <FontAwesome
                name="times"
                className="gallery-image-delete"
                onClick={this.removeImage}
                data-value={image.id}
              />
            )}
          </button>
        ))}
        {(images.length < 4 && isEditable) && (
          <UserGalleryUpload
            triggerInput={this.triggerInput}
            isUploading={isUploading}
            imageInput={this.imageInput}
            addImageToGalery={this.addImageToGalery}
            user={user}
          />
        )}
        <div className={`modal ${ isModalActive ? 'is-active' : '' }`} id="imageModalContainer">
          <div className="modal-background" />
          <div className="modal-content" data-target="images-modal.container">
            <div id="modalContent">
              <img src={modalSrc} alt="User gallery" className="image" />
            </div>
          </div>
          <button type="button" className="modal-close is-large" aria-label="close" onClick={this.closeModal} />
        </div>
      </div>
    );
  }
}

UserGallery.propTypes = {
  user: PropTypes.shape({
    id: PropTypes.number.isRequired,
    profile_image: PropTypes.string,
    images: PropTypes.arrayOf(PropTypes.shape({
      id: PropTypes.number.isRequired,
      url: PropTypes.string.isRequired,
    })).isRequired,
  }),
  isEditable: PropTypes.bool.isRequired,
};

export default UserGallery;
