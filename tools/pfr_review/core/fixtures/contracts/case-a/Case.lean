namespace ReviewFixture

theorem exchange (P Q : Prop) : P ∧ Q → Q ∧ P := by
  intro h
  exact ⟨h.2, h.1⟩

end ReviewFixture
