document.addEventListener('DOMContentLoaded', () => {
  let player;
  let device_id;
  let isTrackLoaded = false;
  const startTime = 30;
  
  const access_token = document.getElementById('access-token-input').value; 
  const track_id = document.getElementById('song-code-input').value; 

  window.onSpotifyWebPlaybackSDKReady = () => {
    player = new Spotify.Player({
      name: 'Web Playback SDK Quick Start Player',
      getOAuthToken: cb => { cb(access_token); },
      volume: 0.5
    });

    player.addListener('ready', ({ device_id: id }) => {
      console.log('Ready with Device ID', id);
      device_id = id;
    });

    player.addListener('player_state_changed', state => {
      console.log('Player state changed', state);
    });

    player.addListener('initialization_error', ({ message }) => {
      console.error('Initialization error', message);
    });

    player.connect();
  };

  function loadTrack() {
    fetch(`https://api.spotify.com/v1/me/player/play?device_id=${device_id}`, {
      method: 'PUT',
      body: JSON.stringify({ uris: [`spotify:track:${track_id}`],  position_ms: startTime * 1000}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': `Bearer ${access_token}`
      },
    }).then(() => {
      console.log('Track loaded');
      isTrackLoaded = true;
    }).catch((error) => {
      console.error('Failed to load track', error);
    });
  }

  document.getElementById('start-loop-button').addEventListener('click', () => {
    if (!isTrackLoaded) {
      loadTrack();
    } else {
      player.togglePlay().then(() => {
        console.log('Toggled play/pause');
      });
    }
  });
});
