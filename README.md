# libansnd

<ins>An</ins>other <ins>S</ins>ou<ins>nd</ins> <ins>Lib</ins>rary for Wii and GameCube homebrew.  

Unlike existing solutions, this library has support for ADPCM audio decoding and proper arbitrary resampling. 
ADPCM is the only compressed audio codec supported in hardware by the Wii and GameCube DSP. 
For context, a mono 16-bit PCM audio stream reduces to ~28.5% of the original size when encoded with ADPCM.

## Features

* Hardware ADPCM decoding
* Arbitrary resampling via windowed sinc interpolation
* Up to 48 simultaneous voices
* Callbacks for voice state & streaming data input
* Looping with arbitrary start & end positions
* Dynamic volume adjustment
* Pitch adjustment
* Configurable playback delay
* Manual ARAM management on GameCube

## Build

libogc and devkitPPC from devkitPro are required to build this library. Installation instructions can be found [here](https://devkitpro.org/wiki/Getting_Started).  
To build libansnd using the built-in devkitPro CMake toolchain file for your console of choice:

```
cd ./build
/opt/devkitpro/portlibs/<console>/bin/powerpc-eabi-cmake ..
cmake --build .
```

Example programs are built by default. To disable, specify `-DBUILD_EXAMPLES=OFF` when initializing CMake  

The streaming example program requires libogg and libvorbisidec. 
If either is not present, then the streaming example will not compile. 
They can be installed via pacman from devkitPro with the following: 
> sudo (dkp-)pacman -S ppc-libogg ppc-libvorbisidec

## Usage

Examples on how to use libansnd are in the Examples directory; there are six in total, and each demonstrates a particular feature of libansnd.  
- [Simple Playback](examples/example_simple_playback/src/main.c): Voice allocation, configuration, starting, and stopping. 
- [Simple Looping](examples/example_simple_looping/src/main.c): Same as simple playback except the voice, once started, plays indefinitely until it is stopped. 
- [State Callback](examples/example_state_callback/src/main.c): Voice state callback, pausing and unpausing a voice. 
- [Pitch](examples/example_pitch/src/main.c): Adjust the pitch of a voice, which is also resampling. 
- [Pitch ADPCM](examples/example_pitch_adpcm/src/main.c): Same as the pitch example using ADPCM encoded samples. 
- [Streaming](examples/example_streaming/src/main.c): Using the streaming data callback.

## Performance Characteristics

Each active voice takes some time to process, and the resampling algorithm is quite costly. 
Not every voice can be played simultaneously while resampling.
Upsampling is cheaper, and downsampling gets more expensive as the frequency ratio gets larger.
To avoid resampling, use a pitch of 1.0 the base sample rate of 48 kHz or 32 kHz depending on what mode the library was initialized with.

Voice processing and user callbacks are handled sequentially; 
as such, it is advised that user callback functions are returned from as quickly as possible.
Taking too long can starve the final audio stream output.

There are two functions that return usage statistics for 'DSP usage' and 'Total usage.' 
- _DSP usage_ is the percentage of available time the DSP used for processing.
- _Total usage_ is the percentage of available time the entire library used for processing, including user callbacks and DSP processing.

Hardware measurements of the percentage of total time it takes the DSP to process a single voice of different types for each console:  

### GameCube:  
> Upsampling - 5.56% (18 total)  
> Non-resampling - 2.56% (39 total)  
> 2x Downsampling - 7.14% (14 total)  
> 4x Downsampling - 10.00% (10 total)  

### Wii:  
> Upsampling - 3.57% (28 total)  
> Non-resampling - 2.08% (48 total)  
> 2x Downsampling - 4.76% (21 total)  
> 4x Downsampling - 6.67% (15 total)
