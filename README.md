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

    ✅ loop
    ✅ duration
    ✅ lifetime
    ✅ start delay
    ✅ shape
    ✅ sizeOverLifetime
    ✅ speedOverLifetime
    ✅ colorOverLifetime
    ✅ rotationOverLifetime (just Z axis)
    ✅ alignToDirection

    ⬜ trail

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
    ⬜ texture fit (cover, contain, stretch, repeat)

## Bugs

    ⬜ position of emission is not correct
    ⬜ fix alignToDirection with attractor to not aim the attractor, but the path to attractor
