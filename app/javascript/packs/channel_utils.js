import axios from './axios_utils.js';

export const filters = {
  'nameAsc': 'Name (A-Z)',
  'nameDesc': 'Name (Z-A)',
  'unread': 'Unread',
  'new': 'New',
  'read': 'Read',
};

export const filterChannels = (filterType, searchValue, channels) => filterSolvers[filterType](searchValue, channels);

const filterSolvers = {
  nameAsc: (name, channels) => {
    const filterRegex = new RegExp(name, 'i');
    let filteredListedChannels = [];

    channels.forEach((channel) => {
      if (filterRegex.test(channel.conversationTitle)) {
        filteredListedChannels = [...filteredListedChannels, channel];
      }
    });
    return filteredListedChannels;
  },
  nameDesc: (name, channels) => {
    const filterRegex = new RegExp(name, 'i');
    let filteredListedChannels = [];

    channels.forEach((channel) => {
      if (filterRegex.test(channel.conversationTitle)) {
        filteredListedChannels = [channel, ...filteredListedChannels];
      }
    });
    return filteredListedChannels;
  },
  unread: async (_, channels) => {
    return await asyncFilter(channels, async (channel) => await hasNewMessage(channel));
  },
  new: async (_, channels) => {
    return await channels.filter((channel) => 'joined' == channel.status)
  },
  read: async (_, channels) => {
    return await asyncFilter(channels, async (channel) => !(await hasNewMessage(channel)));
  },
};

export const autoJoinPendingInvitations = (client) => {
  client.on('channelInvited', (channel) => {
    if (channel.attributes.purpose === 'conversation') {
      channel.join();
    }
  });
};

export const sortChannelsByDate = (channels) => (
  channels.sort((a, b) => {
    const dateA = new Date(b.lastMessage ? b.lastMessage.timestamp : b.dateUpdated);
    const dateB = new Date(a.lastMessage ? a.lastMessage.timestamp : a.dateCreated);
    return dateA - dateB;
  })
);


export const hasNewMessage = async (channel) => {
  const messagesPaginator = await channel.getMessages(1);
  const lastMessage = messagesPaginator.items[0];

  if (!lastMessage) return false;

  return channel.lastConsumedMessageIndex < lastMessage.index;
}

const asyncFilter = async (arr, callback) => {
  const fail = Symbol();
  return (await Promise.all(arr.map(async item => (await callback(item)) ? item : fail))).filter(i=>i!==fail);
}

export const getChannelImage = async (channelSid) => {
  const messageChannelResponse = await axios.get(`/message_channels/${channelSid}`);
  return messageChannelResponse.data.image_url;
}

export const isChannelAGroup = (channel) => channel && channel.attributes.purpose === 'chat_group';

