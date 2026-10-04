namespace ReviewFixture

theorem exchange (P Q : Prop) (hQP : Q ∧ P) : P ∧ Q → Q ∧ P := by
  intro h
  exact hQP

end ReviewFixture
