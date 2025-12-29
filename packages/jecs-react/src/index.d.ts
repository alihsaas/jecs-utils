import { Entity, Id, InferComponents, Query, World } from "@rbxts/jecs";
import React from "@rbxts/react";

export function useEntityGet<T>(entity: Entity | undefined, id: Entity<T>, deps?: unknown[]): T | undefined;

export function useEntityHas<T>(entity: Entity | undefined, id: Entity<T>, deps?: unknown[]): boolean;

export function useQueryFirst<T extends Id[]>(
	query: Query<T>,
	predicator?: (entity: Entity, ...components: InferComponents<T>) => boolean,
	deps?: unknown[]
): Entity | undefined;

export function useQuery(query: Query<Id[]>, deps?: unknown[]): Entity[];

export function useTarget<T extends Id = Entity>(entity: Entity | undefined, relation: Id, deps?: unknown[]): T;

export function useWorld(): World;

export function WorldProvider(props: { world: World }): React.Element
