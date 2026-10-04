import PerfectFunctionalRepresentations.Matrix.Partitions
import PerfectFunctionalRepresentations.Matrix.SingularColumns

/-!
# C10 exact finite-partition consumers

R05-R06 check a proper carrier with unequal-sized blocks and nontrivial label
order, every partition invariant, rejected candidate data, the supplied-label
bijection, singleton and empty boundaries, and the active-column pattern handoff.
Fixtures remain private. The generic consumers have no decidable-equality premise.
-/

namespace PerfectFunctionalRepresentations.Tests.Partitions

noncomputable section
attribute [local instance] Classical.propDecidable

-- Finpartition carries its finset lattice instance in the type. Concrete
-- consumers select the same classical equality used by the generic adapter.
local instance : DecidableEq (Fin 7) := fun a b => Classical.propDecidable (a = b)
local instance : DecidableEq Empty := fun a b => Classical.propDecidable (a = b)
attribute [local simp] Fin.ext_iff

private def carrier : Finset (Fin 7) := {0, 1, 2, 3, 4, 5}

-- Label 0 owns the largest block, label 1 the singleton, and label 2 the pair.
private def blocks (i : Fin 3) : Finset (Fin 7) :=
  if i = 0 then {3, 4, 5} else if i = 1 then {0} else {1, 2}

private theorem blocks_nonempty : ∀ i, (blocks i).Nonempty := by
  simp [Fin.forall_fin_succ, blocks, -Fin.val_eq_zero_iff]

private theorem blocks_disjoint : Pairwise (fun i j => Disjoint (blocks i) (blocks j)) := by
  simp [Pairwise, Fin.forall_fin_succ, blocks, Finset.disjoint_left, -Fin.val_eq_zero_iff]

private theorem blocks_cover : ∀ x, x ∈ carrier ↔ ∃ i, x ∈ blocks i := by
  simp [Fin.forall_fin_succ, Fin.exists_fin_succ, carrier, blocks, -Fin.val_eq_zero_iff]

private def partition :=
  partitionOfBlocks carrier blocks blocks_nonempty blocks_disjoint blocks_cover

private def labels : Fin 3 ≃ partition.parts :=
  partitionOfBlocksEquiv carrier blocks blocks_nonempty blocks_disjoint blocks_cover

private theorem labels_val (i : Fin 3) : (labels i).val = blocks i :=
  partitionOfBlocksEquiv_apply_val carrier blocks blocks_nonempty blocks_disjoint blocks_cover i

-- R05: the supplied carrier is proper, and block sizes and labels are independent data.
example : (6 : Fin 7) ∉ carrier ∧ carrier.card = 6 := by simp [carrier]

example : (labels 0).val = {3, 4, 5} ∧ (labels 1).val = {0} ∧
    (labels 2).val = {1, 2} := by
  simp [labels_val, blocks]

example : (labels 0).val.card = 3 ∧ (labels 1).val.card = 1 ∧
    (labels 2).val.card = 2 := by
  simp [labels_val, blocks]

example (p : partition.parts) : p.val.Nonempty := partition.nonempty_of_mem_parts p.property

example (p q : partition.parts) (hpq : p ≠ q) : Disjoint p.val q.val := by
  exact partition.disjoint p.property q.property (fun h => hpq (Subtype.ext h))

example : partition.parts.biUnion id = carrier := partition.biUnion_parts

example (x : Fin 7) (hx : x ∈ carrier) : ∃! p, p ∈ partition.parts ∧ x ∈ p :=
  partition.existsUnique_mem hx

-- In particular, the out-of-carrier value 6 cannot enter any constructed block.
example (p : partition.parts) : (6 : Fin 7) ∉ p.val := by
  intro h
  exact (show (6 : Fin 7) ∉ carrier by simp [carrier]) (partition.subset p.property h)

example : partition.part (4 : Fin 7) = {3, 4, 5} ∧
    partition.part (0 : Fin 7) = {0} ∧ partition.part (2 : Fin 7) = {1, 2} := by
  have h0 := partition.part_eq_of_mem (labels 0).property
    (a := (4 : Fin 7)) (by simp [labels_val, blocks])
  have h1 := partition.part_eq_of_mem (labels 1).property
    (a := (0 : Fin 7)) (by simp [labels_val, blocks])
  have h2 := partition.part_eq_of_mem (labels 2).property
    (a := (2 : Fin 7)) (by simp [labels_val, blocks])
  simpa [labels_val, blocks] using And.intro h0 (And.intro h1 h2)

-- Each malformed family violates a specific required invariant, despite the others.
private def overlapping (i : Fin 3) : Finset (Fin 7) :=
  if i = 0 then {0, 3, 4, 5} else blocks i

example : (∀ i, (overlapping i).Nonempty) ∧
    (∀ x, x ∈ carrier ↔ ∃ i, x ∈ overlapping i) ∧
    ¬ Pairwise (fun i j => Disjoint (overlapping i) (overlapping j)) := by
  simp [Pairwise, Fin.forall_fin_succ, Fin.exists_fin_succ, overlapping, blocks, carrier,
    Finset.disjoint_left, -Fin.val_eq_zero_iff]

private def missing (i : Fin 3) : Finset (Fin 7) :=
  if i = 2 then {1} else blocks i

example : (∀ i, (missing i).Nonempty) ∧
    Pairwise (fun i j => Disjoint (missing i) (missing j)) ∧
    ¬ (∀ x, x ∈ carrier ↔ ∃ i, x ∈ missing i) := by
  simp [Pairwise, Fin.forall_fin_succ, Fin.exists_fin_succ, missing, blocks, carrier,
    Finset.disjoint_left, -Fin.val_eq_zero_iff]

private def withEmpty (i : Fin 3) : Finset (Fin 7) :=
  if i = 0 then {3, 4, 5} else if i = 1 then {0, 1, 2} else ∅

example : Pairwise (fun i j => Disjoint (withEmpty i) (withEmpty j)) ∧
    (∀ x, x ∈ carrier ↔ ∃ i, x ∈ withEmpty i) ∧
    ¬ (∀ i, (withEmpty i).Nonempty) := by
  simp [Pairwise, Fin.forall_fin_succ, Fin.exists_fin_succ, withEmpty, carrier,
    Finset.disjoint_left, -Fin.val_eq_zero_iff]

private def extra (i : Fin 3) : Finset (Fin 7) :=
  if i = 0 then {3, 4, 5, 6} else blocks i

example : (∀ i, (extra i).Nonempty) ∧
    Pairwise (fun i j => Disjoint (extra i) (extra j)) ∧
    ¬ (∀ x, x ∈ carrier ↔ ∃ i, x ∈ extra i) := by
  simp [Pairwise, Fin.forall_fin_succ, Fin.exists_fin_succ, extra, blocks, carrier,
    Finset.disjoint_left, -Fin.val_eq_zero_iff]

-- The singleton partition reuses mathlib directly, without a duplicate wrapper.
private def singletonPartition : Finpartition carrier := Finpartition.indiscrete (by simp [carrier])

example : singletonPartition.parts = {carrier} := rfl

example (x : Fin 7) (hx : x ∈ carrier) :
    ∃! p, p ∈ singletonPartition.parts ∧ x ∈ p := singletonPartition.existsUnique_mem hx

-- R06: the label equivalence is onto every block and injective on supplied labels.
example : Function.Bijective labels := labels.bijective

example (p : partition.parts) : blocks (labels.symm p) = p.val := by
  rw [← labels_val, labels.apply_symm_apply]

example (i : Fin 3) : labels.symm (labels i) = i := labels.symm_apply_apply i

example : Fintype.card partition.parts = 3 := by
  simpa using (Fintype.card_congr labels).symm

example : Finite partition.parts := inferInstance

example : Nonempty partition.parts := ⟨labels 0⟩

-- The one-label adapter also keeps the entire carrier as its exact supplied block.
private def oneBlock (_ : Unit) : Finset (Fin 7) := carrier

private theorem oneBlock_nonempty : ∀ i, (oneBlock i).Nonempty := by simp [oneBlock, carrier]
private theorem oneBlock_disjoint : Pairwise (fun i j => Disjoint (oneBlock i) (oneBlock j)) := by
  intro i j hij
  exact False.elim (hij (Subsingleton.elim i j))
private theorem oneBlock_cover : ∀ x, x ∈ carrier ↔ ∃ i, x ∈ oneBlock i := by
  intro x
  simp [oneBlock]

example :
    (partitionOfBlocksEquiv carrier oneBlock oneBlock_nonempty oneBlock_disjoint oneBlock_cover
      ()).val = carrier :=
  partitionOfBlocksEquiv_apply_val carrier oneBlock oneBlock_nonempty oneBlock_disjoint
    oneBlock_cover ()

-- An empty label type realizes an empty carrier; no empty part is introduced.
private def noBlocks : Empty → Finset (Fin 7) := Empty.elim
private theorem noBlocks_nonempty : ∀ i, (noBlocks i).Nonempty := fun i => i.elim
private theorem noBlocks_disjoint : Pairwise (fun i j => Disjoint (noBlocks i) (noBlocks j)) := by
  intro i
  exact i.elim
private theorem noBlocks_cover : ∀ x : Fin 7, x ∈ (∅ : Finset (Fin 7)) ↔ ∃ i, x ∈ noBlocks i := by
  simp

private def emptyPartition :=
  partitionOfBlocks ∅ noBlocks noBlocks_nonempty noBlocks_disjoint noBlocks_cover

example : emptyPartition.parts = ∅ := emptyPartition.parts_eq_empty_iff.mpr rfl

example : IsEmpty emptyPartition.parts := by
  let e := partitionOfBlocksEquiv ∅ noBlocks noBlocks_nonempty noBlocks_disjoint noBlocks_cover
  exact ⟨fun p => (e.symm p).elim⟩

-- The carrier element type can itself be empty.
example : Finpartition (∅ : Finset Empty) :=
  partitionOfBlocks (∅ : Finset Empty) (fun i : Empty => i.elim) (fun i => i.elim)
    (fun i => i.elim) (fun x => x.elim)

-- Generic external use needs only finite labels, not decidable equality on either type.
section Generic
universe u v
variable {alpha : Type u} {I : Type v} [Finite I]
variable (s : Finset alpha) (family : I → Finset alpha)
  (hne : ∀ i, (family i).Nonempty)
  (hdis : Pairwise (fun i j => Disjoint (family i) (family j)))
  (hcover : ∀ x, x ∈ s ↔ ∃ i, x ∈ family i)

example : Finpartition s := partitionOfBlocks s family hne hdis hcover

example : I ≃ (partitionOfBlocks s family hne hdis hcover).parts :=
  partitionOfBlocksEquiv s family hne hdis hcover

example (i : I) : (partitionOfBlocksEquiv s family hne hdis hcover i).val = family i :=
  partitionOfBlocksEquiv_apply_val s family hne hdis hcover i

example (x : alpha) (hx : x ∈ s) :
    ∃! p, p ∈ (partitionOfBlocks s family hne hdis hcover).parts ∧ x ∈ p :=
  (partitionOfBlocks s family hne hdis hcover).existsUnique_mem hx

example (hs : s.Nonempty) : Nonempty (partitionOfBlocks s family hne hdis hcover).parts := by
  obtain ⟨p, hp⟩ := (partitionOfBlocks s family hne hdis hcover).parts_nonempty hs.ne_empty
  exact ⟨⟨p, hp⟩⟩

example : Finite (partitionOfBlocks s family hne hdis hcover).parts := inferInstance

end Generic

-- C06 supplies a nonempty active pattern directly to the same exact-partition boundary.
example {alpha beta : Type*} [Fintype alpha] (kappa : alpha → PMF beta)
    (y : activeOutputs kappa) :
    ∃ P : Finpartition (columnPattern kappa y).val,
      Nonempty P.parts ∧ ∀ x, kappa x y.val ≠ 0 → ∃! p, p ∈ P.parts ∧ x ∈ p := by
  let s := (columnPattern kappa y).val
  let family : Unit → Finset alpha := fun _ => s
  have hne : ∀ i, (family i).Nonempty := fun _ => (columnPattern kappa y).property
  have hdis : Pairwise (fun i j => Disjoint (family i) (family j)) := by
    intro i j hij
    exact False.elim (hij (Subsingleton.elim i j))
  have hcover : ∀ x, x ∈ s ↔ ∃ i, x ∈ family i := by simp [family]
  let P := partitionOfBlocks s family hne hdis hcover
  refine ⟨P, ?_, ?_⟩
  · exact ⟨partitionOfBlocksEquiv s family hne hdis hcover ()⟩
  · intro x hx
    exact P.existsUnique_mem ((mem_columnPattern kappa y x).mpr hx)

end
end PerfectFunctionalRepresentations.Tests.Partitions
