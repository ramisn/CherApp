import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import ChatListItem from './ChatListItem';
import magnifierGlass from '../../../assets/images/cherapp-ownership-coborrowing-magnifier-white.svg';
import filterIcon from '../../../assets/images/cherapp-ownership-coborrowing-filter.svg';
import axios from '../../packs/axios_utils.js';
import emptyStateImage from '../../../assets/images/cherapp-ownership-coborrowing-recent_messages_empty.svg';
import { filterChannels, autoJoinPendingInvitations, sortChannelsByDate, filters } from '../../packs/conversation_utils';

const Conversations = ({ userRole, isConciergeContact }) => {
  const [inputValue, setInputValue] = useState('');
  const [chatClient, setChatClient] = useState(null);
  const [isClientReady, setIsClientReady] = useState(false);
  const [messageChannels, setMessageChannels] = useState([]);
  const [groupChannels, setGroupChannels] = useState([]);
  const [filteredChannels, setFilteredChannels] = useState([]);
  const [filteredGroupsChannels, setFilteredGroupsChannels] = useState([]);
  const [sectionActive, setSectionActive] = useState('friends');
  const [showFilterMenu, setShowFilterMenu] = useState(false);
  const [filterType, setFilterType] = useState('nameAsc');

  const updateInput = async (searchValue) => {
    setInputValue(searchValue);
    const filteredChannelByName = await filterChannels(filterType, searchValue, messageChannels);
    const filteredGroupChannelByName = await filterChannels(filterType, searchValue, groupChannels);
    setFilteredGroupsChannels(filteredGroupChannelByName);
    setFilteredChannels(filteredChannelByName);
  };

  const setupTwilioClient = (token) => {
    Twilio.Chat.Client.create(token)
    .then((client) => {
      setChatClient(client);
      setIsClientReady(true);
      autoJoinPendingInvitations(client);
    });
  };

  useEffect(() => {
    axios.post('/chat_tokens')
    .then((response) => {
      if (response.status === 200) {
        setupTwilioClient(response.data);
      }
    });
  }, []);

  useEffect(() => {
    const sortedChannels = sortChannelsByDate(messageChannels);
    setFilteredChannels(sortedChannels);
  }, [messageChannels]);

  useEffect(() => {
    const sortedChannels = sortChannelsByDate(groupChannels);
    setFilteredGroupsChannels(sortedChannels);
  }, [groupChannels]);

  useEffect(() => {
    (async () => { await updateInput('')})()
  }, [filterType])

  const listConversation = (userChannel) => {
    if (userChannel.attributes.purpose === 'chat_group') {
      setGroupChannels((prevGroupChannels) => (
        [...prevGroupChannels, userChannel]
      ));
    } else {
      setMessageChannels((prevMessageChannels) => (
        [...prevMessageChannels, userChannel]
      ));
    }
  };

  const processChannelPaginator = (channelPaginator) => {
    channelPaginator.items.forEach((channel) => {
      chatClient.getChannelBySid(channel.sid)
      .then((userChannel) => {
        listConversation(userChannel);
      });
    });

    if (channelPaginator.state.nextToken) {
      channelPaginator.nextPage()
      .then((paginator) => {
        processChannelPaginator(paginator);
      });
    }
  };

  const processChannels = () => {
    chatClient.getUserChannelDescriptors()
    .then((paginator) => {
      processChannelPaginator(paginator);
    });
  };

  useEffect(() => {
    if (!isClientReady) return;

    processChannels();
  }, [isClientReady]);

  const dashboardLinkPath = () => (
    userRole === 'co_borrower' ? '/co-borrower/dashboard' : '/customer/dashboard'
  );

  const searchInput = () => (
    <div className="field has-submit-beside is-primary">
      <input
        type="text"
        placeholder="Search"
        className="input is-primary has-submit-beside"
        onChange={async (event) => { await updateInput(event.target.value); }}
      />
      <div className="control">
        <button className="button" type="button">
          <img src={magnifierGlass} alt="Magnifier glass" />
        </button>
      </div>
    </div>
  );

  const emptyStatusForGroups = () => sectionActive === 'groups' && !filteredGroupsChannels.length;

  const emptyStatusForConversations = () => sectionActive !== 'groups' && !filteredChannels.length;

  const showEmptyStateConversation = () => emptyStatusForGroups() || emptyStatusForConversations();

  const tabsHeaders = () => (
    <div className="column is-12">
      <div className="columns is-marginless is-mobile">
        <div className="column is-fully-centered">
          <button
            type="button"
            className={`button has-no-style ${ sectionActive === 'friends' ? 'has-text-primary is-bold' : ''}`}
            onClick={() => { setSectionActive('friends'); }}
          >
            Friends
          </button>
        </div>
        <div className="column is-fully-centered">
          <button
            type="button"
            className={`button has-no-style ${ sectionActive === 'groups' ? 'has-text-primary is-bold' : ''}`}
            onClick={() => { setSectionActive('groups'); }}
          >
            Groups
          </button>
        </div>
        {isConciergeContact && (
          <div className="column is-fully-centered">
            <button
              type="button"
              className={`button has-no-style ${ sectionActive === 'concierge' ? 'has-text-primary is-bold' : ''}`}
              onClick={() => { setSectionActive('concierge'); }}
            >
              Concierge
            </button>
          </div>
        )}
      </div>
    </div>
  );

  const filterLabel = () => (
    <div
      className="is-flex has-items-centered m-l-sm m-r-sm is-hidden-mobile"
      onMouseOver={() => !showFilterMenu && setShowFilterMenu(true)}
    >
      <span className="has-text-dark">Filtered by:&nbsp;</span>
      <span className="has-text-primary">{filters[filterType]}</span>
      <img src={filterIcon} alt="Filter" className="m-l-md"/>
    </div>
  )

  const filterMenu = () => ( 
    <>
      <div className="is-relative has-full-width is-hidden-mobile">
        <div
          className="chat-filter-menu"
          onMouseLeave={() => (showFilterMenu && setShowFilterMenu(false))}
        >
          {filterLabel()}
          { Object.keys(filters).map((key) => (
            <button
              key={key}
              className="link is-link is-primary is-bold is-block m-t-sm m-l-sm m-r-sm"
              onClick={() => setFilterType(key)}
            >{filters[key]}</button>
          )) }
        </div>
      </div>
      <div className="is-hidden-tablet select has-full-width">
        <select id="filterType" onChange={(e) => setFilterType(e.target.value)}>
          <option value='nameAsc'>
            Filtered by:&nbsp; {filters[filterType]}
          </option>
          { Object.keys(filters).map((key) => (
            <option
              key={key}
              className="link is-link is-primary is-bold is-block m-t-sm m-l-sm m-r-sm"
              value={key}
            >{filters[key]}</option>
          )) }
        </select>
      </div>
    </>
  )

  return (
    <div className="columns is-multiline is-marginless">
      <div className="column is-12-mobile is-12-tablet chat-header is-block">
        <a className="button is-primary is-pulled-right is-hidden-mobile" href="/chat-groups/new"><i className="fas fa-plus m-r-sm is-size-7"></i> Create new group</a>
        <a className="link is-hidden-tablet is-pulled-right m-t-xs" href={dashboardLinkPath()}>Back to dashboard</a>
        <h1 className="is-size-5 has-text-left-mobile">Messages</h1>
        <a className="button is-primary m-t-md is-fullwidth is-hidden-tablet" href="/chat-groups/new"> <i className="fas fa-plus m-r-sm is-size-7"></i> Create new group</a>
      </div>
      <div className="column is-12-mobile is-6-tablet is-5-widescreen">{searchInput()}</div>
      <div className="column is-12-mobile is-narrow-tablet is-flex is-justified-end-tablet">
        { showFilterMenu ? filterMenu() : filterLabel() }
      </div>
      {tabsHeaders()}
      <div className="column is-12">
        <a href="/chat-groups/new" className="is-bold link">+ Create new group</a>
      </div>
      <hr />
      { isClientReady && (
        <div className="column is-12-mobile is-12-tablet">
          <ul className="chat-list-items">
            <div className={ sectionActive === 'groups' ? '' : 'is-hidden'}>
              {filteredGroupsChannels.map((channel) => (
                <ChatListItem channel={channel} key={channel.sid} />
              ))}
            </div>
            <div className={ sectionActive === 'friends' ? '' : 'is-hidden'}>
              {filteredChannels.map((channel) => channel.attributes.purpose !== 'concierge' && (
                <ChatListItem channel={channel} key={channel.sid} />
              ))}
            </div>
            { isConciergeContact && (
              <div className={ sectionActive === 'concierge' ? '' : 'is-hidden'}>
                {filteredChannels.map((channel) => channel.attributes.purpose === 'concierge' && (
                  <ChatListItem channel={channel} key={channel.sid} />
                ))}
              </div>
            )}
          </ul>
          {showEmptyStateConversation() && (
            <div className="has-text-centered m-t-md">
              <img src={emptyStateImage} alt="Cell phone" />
              <span className="has-text-weight-bold is-lighter-blue is-block">You haven't received any messages yet</span>
              <a href="/conversations/new" className="button is-primary m-t-md">Browse contacts</a>
            </div>
          )}
        </div>
      )}
    </div>
  );
};

Conversations.propTypes = {
  userRole: PropTypes.string.isRequired,
  isConciergeContact: PropTypes.bool,
};

export default Conversations;
