use cairo_lib::hashing::hasher::Hasher;
use cairo_lib::utils::types::words64::Words64;
use poseidon::hades_permutation;

// @notice Hashes the given words using the Poseidon hash function.
// @param words The words to hash
// @return The hash of the words
fn hash_words64(words: Words64) -> felt252 {
    0
}

// Permutation params: https://docs.starknet.io/documentation/architecture_and_concepts/Cryptography/hash-functions/#poseidon_hash
impl PoseidonHasher of Hasher<felt252, felt252> {
    // @inheritdoc Hasher
    fn hash_single(a: felt252) -> felt252 {
        let (single, _, _) = hades_permutation(a, 0, 1);
        single
    }

    // @inheritdoc Hasher
    fn hash_double(a: felt252, b: felt252) -> felt252 {
        let (double, _, _) = hades_permutation(a, b, 2);
        double
    }

    // @inheritdoc Hasher
    fn hash_many(input: Span<felt252>) -> felt252 {
        0
    }
}
