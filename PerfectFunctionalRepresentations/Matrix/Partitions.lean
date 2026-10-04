import Mathlib.Order.Partition.Finpartition

/-!
# Exact partitions of finite input patterns

The exact-partition boundary uses mathlib `Finpartition` on a finite set of
inputs. Its existing API supplies nonempty parts, disjointness, coverage, unique
membership and the singleton partition. This module adds the labelled-family
adapter needed by later matrix constructions: it retains the supplied labels
through an explicit equivalence with the resulting parts.

The input alphabet need not be finite or carry a decidable equality instance.
Only the block-label type is finite. Empty carriers are permitted and have no
parts; an active column's nonempty pattern gives a nonempty family of parts.
Partition enumeration and incidence matrices belong to later modules.

`Finpartition` carries its lattice instance in its type. Consumers use the same
local classical decidability before partition-typed declarations; concrete input
types with an existing equality decision may need an explicit local classical
`DecidableEq` instance, as illustrated in the regression module.
-/

namespace PerfectFunctionalRepresentations

noncomputable section
attribute [local instance] Classical.propDecidable

universe u v
variable {alpha : Type u} {I : Type v}

private theorem blocks_injective (blocks : I → Finset alpha)
    (hne : ∀ i, (blocks i).Nonempty)
    (hdis : Pairwise (fun i j => Disjoint (blocks i) (blocks j))) :
    Function.Injective blocks := by
  intro i j hij
  by_contra hneij
  obtain ⟨x, hx⟩ := hne i
  exact Finset.disjoint_left.mp (hdis hneij) hx (hij ▸ hx)

/-- Construct an exact partition from a finite labelled family of nonempty,
pairwise disjoint blocks with exactly the prescribed carrier. -/
def partitionOfBlocks [Finite I] (s : Finset alpha) (blocks : I → Finset alpha)
    (hne : ∀ i, (blocks i).Nonempty)
    (hdis : Pairwise (fun i j => Disjoint (blocks i) (blocks j)))
    (hcover : ∀ x, x ∈ s ↔ ∃ i, x ∈ blocks i) : Finpartition s := by
  letI := Fintype.ofFinite I
  refine Finpartition.ofExistsUnique (Finset.univ.image blocks) ?_ ?_ ?_
  · intro p hp x hx
    obtain ⟨i, _, rfl⟩ := Finset.mem_image.mp hp
    exact (hcover x).mpr ⟨i, hx⟩
  · intro x hx
    obtain ⟨i, hi⟩ := (hcover x).mp hx
    refine ⟨blocks i, ⟨Finset.mem_image.mpr ⟨i, Finset.mem_univ i, rfl⟩, hi⟩, ?_⟩
    intro p hp
    obtain ⟨j, _, rfl⟩ := Finset.mem_image.mp hp.1
    have hji : j = i := by
      by_contra hji
      exact Finset.disjoint_left.mp (hdis hji) hp.2 hi
    exact congrArg blocks hji
  · intro he
    obtain ⟨i, _, hi⟩ := Finset.mem_image.mp he
    exact (hne i).ne_empty hi

/-- Every supplied label corresponds to exactly its original block. The
nonempty-disjoint hypotheses rule out two labels for the same block. -/
def partitionOfBlocksEquiv [Finite I] (s : Finset alpha) (blocks : I → Finset alpha)
    (hne : ∀ i, (blocks i).Nonempty)
    (hdis : Pairwise (fun i j => Disjoint (blocks i) (blocks j)))
    (hcover : ∀ x, x ∈ s ↔ ∃ i, x ∈ blocks i) :
    I ≃ (partitionOfBlocks s blocks hne hdis hcover).parts := by
  letI := Fintype.ofFinite I
  let f : I → (partitionOfBlocks s blocks hne hdis hcover).parts := fun i =>
    ⟨blocks i, by
      change blocks i ∈ Finset.univ.image blocks
      exact Finset.mem_image.mpr ⟨i, Finset.mem_univ i, rfl⟩⟩
  refine Equiv.ofBijective f ⟨?_, ?_⟩
  · intro i j hij
    exact blocks_injective blocks hne hdis (congrArg Subtype.val hij)
  · intro b
    have hb := b.property
    change b.val ∈ Finset.univ.image blocks at hb
    obtain ⟨i, _, hi⟩ := Finset.mem_image.mp hb
    exact ⟨i, Subtype.ext hi⟩

/-- The label-to-part equivalence preserves the supplied block as a finset. -/
@[simp]
theorem partitionOfBlocksEquiv_apply_val [Finite I] (s : Finset alpha)
    (blocks : I → Finset alpha) (hne : ∀ i, (blocks i).Nonempty)
    (hdis : Pairwise (fun i j => Disjoint (blocks i) (blocks j)))
    (hcover : ∀ x, x ∈ s ↔ ∃ i, x ∈ blocks i) (i : I) :
    (partitionOfBlocksEquiv s blocks hne hdis hcover i).val = blocks i := rfl

end

end PerfectFunctionalRepresentations
