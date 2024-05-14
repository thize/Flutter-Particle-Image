# Particle Image

## PD_Events ✅

    ✅ onEachParticleStart
    ✅ onFirstParticleFinished
    ✅ onAnyParticleFinished
    ✅ onLastParticleFinished

## PD_Movement ✅

    ✅ velocity
    ✅ gravity
    ✅ attractor
    ✅ vortex

## PD_Settings

    ✅ loop
    ✅ start delay
    ✅ duration
    ✅ lifetime
    ✅ shape

    ✅ size
    ✅ sizeOverLifetime

    ✅ speed
    ✅ speedOverLifetime

    ✅ color
    ⬜ colorOverLifetime

    ✅ rotation
    ⬜ rotationOverLifetime

    ⬜ trail

    ⬜ alignToDirection

## PD_Emission

    ✅ rate per second
    ✅ PD_EmissionShape
        ✅ point
        ✅ line
        ✅ circle
        ✅ rectangle
        ✅ directional
    ✅ PD_EmissionShape direction
        ✅ point
        ✅ line
        ✅ circle
        ✅ rectangle
        ✅ directional
    ✅ bursts
    ✅ rate over duration
    ⬜ emission shape uniform

## Others

    ✅ controller
    ✅ sub particle
    ✅ color work with texture
    ⬜ size not uniform with texture
    ⬜ add rotation using Matrix4

## Bugs

    ⬜ particle is not being removed if ParticleImage is bigger than lifetime
    ⬜ particle rotated by transform is not respecting the gravity
