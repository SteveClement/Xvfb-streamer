# Stream your X Session

This gives you an "easy" way to stream an Xorg session to either Twitch or YouTube and optionally re-stream Audio from the 3rd party stream.

## Requirements

```bash
sudo apt install tmuxinator xdotool wmctrl imagemagick inotify-tools httpie xosd-bin
```

## Layout

4 panes will be setup:

* Xvfb for the actual X Session and an attach to the terminal you want to monitor
* An upstream to Twitch
* An upstream to YouTube
* The image overlay script to be reloaded on changes to a file

## Starting

As we use tmuxinator, make sure to adapt **stream.yml** and copy to **~/.tmuxinator**
```bash
mkdir -p ~/.tmuxinator
cp stream.yml ~/.tmuxinator
mux s stream
```

[ImageMagick Generate Text Images](http://www.imagemagick.org/Usage/text/)

[ponysay](https://github.com/erkin/ponysay) [Debian Package](http://www.vcheng.org/ponysay/)

This work by [@SteveClement](https://twitter.com/SteveClement) is licensed under the Non-White-Heterosexual-Male License.
