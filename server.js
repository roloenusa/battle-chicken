const config = require('config');
const Discord = require('discord.js');
const client = new Discord.Client();

function formatReport(embed) {
  const url = embed.url.split('/');
  const report = url[url.length - 2];

  var event = [];
  event.push(`**${embed.description}**\n`);
  config.urls.forEach(url => {
    event.push(url.replace(/%s/, report));
  });
  return event.join("\n");
}

console.log(config);

client.on('ready', () => {
  console.log("BOT has been initialized.");
  let targetGuild = client.guilds.find('name', config.smoke.target_guild_name);
  let targetChannel = targetGuild.channels.find('name', config.smoke.target_channel_name);

  let sourceGuild = client.guilds.find('name', config.smoke.source_guild_name);
  let sourceChannel = sourceGuild.channels.find('name', config.smoke.source_channel_name);

  // List servers the bot is connected to
  sourceChannel.fetchMessages({ limit: 5 })
  .then(messages => {
    console.log(`Received ${messages.size} messages`)
    messages.forEach(message => {

      if (message.author.id == 490964479891341312) {

        message.embeds.forEach(embed => {
          console.log("\n========");
          console.log(embed.description);
          console.log(embed.url);

          const response = formatReport(embed);
          targetChannel.send(response);
        });
      }
    })
  })
  .catch(console.error);
});


client.on('message', message => {
  // Prevent bot from responding to its own messages
  if (message.author == client.user) {
      return
  }

  if (message.content === 'ping') {
    message.channel.send("pong");
  }

  if (message.author.id == config.warcraftlogs_userid) {
    message.embeds.forEach(embed => {
      console.log("======== \n");
      console.log(embed.description);
      console.log(embed.url);

      const response = formatReport(embed);
      message.channel.send(response);
    });
  }
});

client.login(config.bot_secret_token);