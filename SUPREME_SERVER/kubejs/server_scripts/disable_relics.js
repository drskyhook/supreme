LootJS.modifiers((event) => {
  event
    .addLootTableModifier(/.*/)
    .removeLoot("relics:infinity_ham")
    .removeLoot("relics:phoenix_feather")
    .removeLoot("relics:holy_locket");
});
