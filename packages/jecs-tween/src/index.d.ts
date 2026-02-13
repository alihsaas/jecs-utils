import { Entity, Tag, World } from "@rbxts/jecs";
import { TweenOptions } from "@rbxts/ripple";

interface JecsTween {
	options: Entity<TweenOptions>;
	goal: Tag;
	completed: Tag;
	motion: Entity<Tween>;

	world: (world: World) => void;
	system: (delta: number) => void;
}

declare const jecs_tween: JecsTween;

export const options: Entity<TweenOptions>;
export const goal: Tag;
export const completed: Tag;
export const motion: Entity<Tween>;

export function world(world: World): void;
export function system(delta: number): void;

export default jecs_tween;
