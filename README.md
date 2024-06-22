# Particle Image

## PD_Events

    ✅ onEachParticleStart
    ✅ onFirstParticleFinished
    ✅ onAnyParticleFinished
    ✅ onLastParticleFinished

## PD_Movement

    ✅ velocity
    ✅ gravity
    ✅ attractor
    ✅ vortex

## PD_Settings

    ⬜ loop
    ✅ duration
    ✅ lifetime
    ✅ start delay
    ✅ shape
    ✅ sizeOverLifetime
    ✅ speedOverLifetime
    ✅ colorOverLifetime
    ✅ rotationOverLifetime (just Z axis)

    ⬜ trail

    ⬜ alignToDirection

## PD_Emission

    ✅ rate per second
    ✅ rate over duration
    ✅ bursts
    ✅ PD_EmissionShape
        ✅ point
        ✅ line
        ✅ circle
        ✅ rectangle
        ✅ directional
    ⬜ emission shape uniform

## Others

    ✅ controller
    ✅ color work with texture
    ✅ sub particle
    ⬜ loop each sub particle
    ⬜ events outside of particle (inside of particle emitter)
    ⬜ add rotation using Matrix4
    ⬜ texture is not fit to size (cover, contain, stretch, repeat)