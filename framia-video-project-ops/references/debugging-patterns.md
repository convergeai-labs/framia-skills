# Framia Video Debugging Patterns

## Evidence order

1. Visible project and node identity.
2. Real player state and screenshots.
3. Editor timeline tracks and durations.
4. Export status and stable resource ID.
5. Console/network evidence.
6. Framia agent narrative last.

This order prevents a confident agent report from hiding an empty timeline, stale asset, or semantically wrong video.

## Browser and MCP route

- Reuse the authenticated browser only for the user-authorized Framia project.
- Orient with one DOM snapshot, then scope locators to a node `data-testid` or stable `data-id`.
- Inspect a node title's ancestors when the test ID is not exposed in the accessibility tree.
- Open the final editor and read the timeline duration, clip labels, audio track, and player state.
- Use the browser `pageAssets` capability to inventory observed images/video. Bundle only the exact assets needed.
- A `pageAssets.bundle()` CORS failure is an extraction failure, not proof that media is unavailable. Fall back to visible player playback, screenshots, an authorized download action, or a local copy without exposing signed URLs.
- Use resource IDs in durable evidence. Signed CDN URLs expire and may carry credential-like query parameters.

## Failure signatures

### `storyboard has no renderable video clips`

Likely state:

- nodes are connected but the editor timeline has no placed video clips;
- the storyboard references metadata rather than renderable media;
- the editor was created before clip generation completed.

Route:

1. Open the editor and confirm the timeline is empty.
2. Verify each source clip is generated and playable.
3. Create a fresh editor node or explicitly place the clips.
4. Confirm video tracks exist before rendering.

### `Container artifact failed (404): Not found`

Likely state:

- stale or missing asset reference;
- expired intermediate container artifact;
- rerun points at an old output target.

Route:

1. Identify which clip/audio reference is missing.
2. Verify each input independently.
3. Reattach fresh resource IDs to a new editor node.
4. Run a short video-only export gate before the full composition.
5. Add audio only after the video path succeeds.

### `context deadline exceeded` or indeterminate submit

Do not wait indefinitely. The export may be stuck, rejected, or eventually accepted without returning.

Route:

1. Check whether the timeline is empty.
2. Check total duration, clip count, audio metadata, and output status.
3. Inspect whether a resource ID appeared despite the timeout.
4. If state is unchanged, stop blind polling and create a fresh editor node.
5. Isolate video-only, shorter-duration, and audio-added variants to find the failing envelope.

### Short composition succeeds but longer composition fails

Treat this as a renderer-envelope problem, not proof the clips are bad.

1. Export one clip.
2. Export two clips without BGM.
3. Add BGM.
4. Add the remaining clip.
5. Keep successful intermediate evidence, but do not call it the requested final result.

## Bounded Framia-agent prompt

Include:

- exact source node and reproducible defects;
- timestamp or segment for each defect;
- invariant-based acceptance criteria;
- new node/version name;
- model, ratio, duration, and resolution;
- explicit exclusions: preserve old nodes, no delete/share/publish;
- required report: clip IDs, BGM ID, final ID, actual properties, residual defects.

Ask the agent to inspect generated clips and regenerate visible failures before assembling the final timeline.

## Verification after agent completion

1. Locate the new node by exact name or test ID.
2. Confirm source nodes still exist.
3. Open the new editor; verify non-empty tracks, clip order, BGM, and duration.
4. Play the opening, each boundary, climax, and ending at normal speed.
5. Compare against the baseline acceptance matrix.
6. Check that export media loads; separately record thumbnail/CORS problems.
7. Report only what was independently observed.
