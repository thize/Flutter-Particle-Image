# TODO ParticleData

## Progress

    ✅ Done
    🟦 Necessary to 80/20
    ⬜ Not Started

## PD_Events ✅

    ✅ onEachParticleStart
    ✅ onFirstParticleFinished
    ✅ onAnyParticleFinished
    ✅ onLastParticleFinished

## PD_Settings ✅

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
    ✅ rotationOverLifetime

    🟦 trail

    ⬜ alignToDirection

## PD_Movement ✅

    ✅ velocity
    ✅ gravity
    ✅ attractor
    ✅ vortex
    ⬜ noise

## PD_Emission ✅

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
    ⬜ color work with images
    ⬜ add rotation using Matrix4
    ⬜ square shape change to rectangle

## Particle Creator

    ⬜ particle editor
    ⬜ particle to/from json
    ⬜ (Unity - UI Particle Image) to Flutter

## Bugs

    ⬜ particle is not being removed if ParticleImage is bigger than lifetime
    ⬜ particle rotated is not respecting the gravity
