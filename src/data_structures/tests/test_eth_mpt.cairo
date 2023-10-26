use cairo_lib::data_structures::eth_mpt::{MPTNode, MPTTrait};
use cairo_lib::utils::types::words64::Words64TryIntoU256LE;

#[test]
#[available_gas(9999999999)]
fn test_decode_rlp_node_branch() {
    let rlp_node = array![
        0x09cf7077a01102f9,
        0xa962df351b7a06b5,
        0xadecaece75818924,
        0x0c4044a8b4cd681f,
        0x85a31ea0f44ac173,
        0x045c6d4661b25ad0,
        0x1a9fc1344568fe87,
        0x35361adc184b5c4b,
        0x4c2ca0b471500260,
        0x1846d1d34035ce04,
        0x8366e5a5533c3072,
        0x0c80a8368d4f30c1,
        0xa9a0eecd3ffaf56a,
        0xc4d37d4bc58d77dc,
        0xb0fe61d139e72282,
        0x3717d5dcb2ceeec0,
        0xa05138a6378e5bf0,
        0xdd62df56554d5fa9,
        0x9b56ae97049962c2,
        0x9307207bdafd8ecd,
        0xd71897db4cded3f8,
        0x2238146d06d439a0,
        0x74a843e9c94aaf6e,
        0xb91dd8b05fc2a9a9,
        0x03e2b336138c1d86,
        0x6ab4637ccc7aa04c,
        0x25a141a0c9b318a4,
        0x7a396b316173cb6b,
        0x13bb1b4967885ada,
        0x25818a3515a03001,
        0xc736fe137193c42e,
        0x3497a1fb11b74680,
        0x5f78007a1829bb91,
        0xd3429168a0ae52f8,
        0xdfce8b1ca7faab16,
        0x254e10b2db1d2049,
        0x1f2256e8c490dc0a,
        0x5036dca058964a53,
        0xa714a3a8fd342599,
        0xb59dc7a83baeb0db,
        0xc060242ace690c55,
        0xb020a0a3c1c4ad07,
        0xe19e05b055663b68,
        0xc1cb6b504b4ed003,
        0x11b1dab792630039,
        0x8ea0e7420366c278,
        0xd91c0f63fb45ebed,
        0xcb17225718eb3697,
        0x03e21bb715f3d5c6,
        0xa014269bd9e83cb0,
        0x6f985af63da32379,
        0x69b9c2e4e6f9e7d5,
        0x3999be4e94086b73,
        0xf309e62f6114864a,
        0x71201ad0d73465a0,
        0xce46b9552afba44a,
        0xa22aadff2d22c364,
        0xb12ac97334928ad1,
        0xb8fe8bc2f9bfa0fd,
        0xb0c3c818b6a92dbf,
        0x4714bdc0b10ce86f,
        0xe229ff6121c4f738,
        0x3c6961147fa02f50,
        0x5ea3bb1b02a54e70,
        0x8f459e43f602c572,
        0x8fea4837d02e2498,
        0x805fb3e2
    ];

    let expected: Span<u256> = array![
        0xF44AC1730C4044A8B4CD681FADECAECE75818924A962DF351B7A06B509CF7077,
        0xB47150026035361ADC184B5C4B1A9FC1344568FE87045C6D4661B25AD085A31E,
        0xEECD3FFAF56A0C80A8368D4F30C18366E5A5533C30721846D1D34035CE044C2C,
        0x5138A6378E5BF03717D5DCB2CEEEC0B0FE61D139E72282C4D37D4BC58D77DCA9,
        0xD71897DB4CDED3F89307207BDAFD8ECD9B56AE97049962C2DD62DF56554D5FA9,
        0x4C03E2B336138C1D86B91DD8B05FC2A9A974A843E9C94AAF6E2238146D06D439,
        0x300113BB1B4967885ADA7A396B316173CB6B25A141A0C9B318A46AB4637CCC7A,
        0xAE52F85F78007A1829BB913497A1FB11B74680C736FE137193C42E25818A3515,
        0x58964A531F2256E8C490DC0A254E10B2DB1D2049DFCE8B1CA7FAAB16D3429168,
        0xA3C1C4AD07C060242ACE690C55B59DC7A83BAEB0DBA714A3A8FD3425995036DC,
        0xE7420366C27811B1DAB792630039C1CB6B504B4ED003E19E05B055663B68B020,
        0x14269BD9E83CB003E21BB715F3D5C6CB17225718EB3697D91C0F63FB45EBED8E,
        0xF309E62F6114864A3999BE4E94086B7369B9C2E4E6F9E7D56F985AF63DA32379,
        0xFDB12AC97334928AD1A22AADFF2D22C364CE46B9552AFBA44A71201AD0D73465,
        0x2F50E229FF6121C4F7384714BDC0B10CE86FB0C3C818B6A92DBFB8FE8BC2F9BF,
        0x5FB3E28FEA4837D02E24988F459E43F602C5725EA3BB1B02A54E703C6961147F
    ]
        .span();

    let decoded = MPTTrait::decode_rlp_node(rlp_node.span()).unwrap();
    match decoded {
        MPTNode::Branch((
            hashes, value
        )) => {
            assert(value.is_empty(), 'Wrong value');

            let mut i = 0;
            loop {
                if i >= hashes.len() {
                    break ();
                }
                assert((*hashes.at(i)).try_into().unwrap() == *expected.at(i), 'Wrong hash');
                i += 1;
            };
        },
        MPTNode::Extension(_) => {
            panic_with_felt252('Branch node differs');
        },
        MPTNode::Leaf(_) => {
            panic_with_felt252('Branch node differs');
        },
    }
}

#[test]
#[available_gas(9999999999)]
fn test_decode_rlp_node_leaf_odd() {
    let rlp_node = array![
        0x7a99fc8c339d66f8,
        0x65a125ac67212582,
        0x9f1beb530373d980,
        0xd0c4824c0ebf6b0c,
        0x96a0800144f846b8,
        0x2089d02a8ffbbdc4,
        0x66e96f21f693ad0b,
        0xd8bf551b76e2f952,
        0xa0f6ca6e3dad15a7,
        0x667a66e16ef9364e,
        0xa085d1c457acfa3d,
        0x9d07e017a2a369e3,
        0xc71a5df8340f6249
    ];

    let expected_key_end = array![
        0x2125827a99fc8c33, 0x73d98065a125ac67, 0xbf6b0c9f1beb5303, 0xd0c4824c0e
    ];
    let expected_value = array![
        0xbdc496a0800144f8,
        0xad0b2089d02a8ffb,
        0xf95266e96f21f693,
        0x15a7d8bf551b76e2,
        0x364ea0f6ca6e3dad,
        0xfa3d667a66e16ef9,
        0x69e3a085d1c457ac,
        0x62499d07e017a2a3,
        0xc71a5df8340f
    ];

    let decoded = MPTTrait::decode_rlp_node(rlp_node.span()).unwrap();
    let expected_node = MPTNode::Leaf((expected_key_end.span(), expected_value.span(), 1, 57));
    assert(decoded == expected_node, 'Even leaf node differs');
}

#[test]
#[available_gas(9999999999)]
fn test_decode_rlp_node_leaf_even() {
    let rlp_node = array![
        0x7a99fc8c239d66f8,
        0x65a125ac67212582,
        0x9f1beb530373d980,
        0xd0c4824c0ebf6b0c,
        0x96a0800144f846b8,
        0x2089d02a8ffbbdc4,
        0x66e96f21f693ad0b,
        0xd8bf551b76e2f952,
        0xa0f6ca6e3dad15a7,
        0x667a66e16ef9364e,
        0xa085d1c457acfa3d,
        0x9d07e017a2a369e3,
        0xc71a5df8340f6249
    ];

    let expected_key_end = array![
        0x2125827a99fc8c23, 0x73d98065a125ac67, 0xbf6b0c9f1beb5303, 0xd0c4824c0e
    ];
    let expected_value = array![
        0xbdc496a0800144f8,
        0xad0b2089d02a8ffb,
        0xf95266e96f21f693,
        0x15a7d8bf551b76e2,
        0x364ea0f6ca6e3dad,
        0xfa3d667a66e16ef9,
        0x69e3a085d1c457ac,
        0x62499d07e017a2a3,
        0xc71a5df8340f
    ];

    let decoded = MPTTrait::decode_rlp_node(rlp_node.span()).unwrap();
    let expected_node = MPTNode::Leaf((expected_key_end.span(), expected_value.span(), 2, 56));
    assert(decoded == expected_node, 'Even leaf node differs');
}

#[test]
#[available_gas(9999999999)]
fn test_hash_rlp_node() {
    let mut rlp_node = array![
        0x7a99fc8c339d66f8,
        0x65a125ac67212582,
        0x9f1beb530373d980,
        0xd0c4824c0ebf6b0c,
        0x96a0800144f846b8,
        0x2089d02a8ffbbdc4,
        0x66e96f21f693ad0b,
        0xd8bf551b76e2f952,
        0xa0f6ca6e3dad15a7,
        0x667a66e16ef9364e,
        0xa085d1c457acfa3d,
        0x9d07e017a2a369e3,
        0xc71a5df8340f6249
    ];

    let hash = MPTTrait::hash_rlp_node(rlp_node.span());
    assert(
        hash == 0x035F9A54E8BEE015293EB9791C7FEC6A4A111DB8B32464597B6F8E63B1167FA1,
        'Wrong node rlp hash'
    );
}

#[test]
#[available_gas(9999999999999)]
fn test_full_verify() {
    //// Account : 0x7b5C526B7F8dfdff278b4a3e045083FBA4028790 | Goerli | Block 9000000
    ////"0xf90211a0f09eae4e1e51fdde02a2884e285b8a8a9c72cc7e7cdaeef013714e3499bcd475a0ce33fd7097055e50d64c42759027e41ffb22d5b2a03ee67207dc94b547e40956a04817bf75497b71a78957ff89d05107cbf16ead02f7e68f13cead9e7d24dfcda5a00751841dcd0e21ff273930aa4722cabae7ea4e09d0f4e9f667b57ab68a41652ea047008ee2caeec1839c016d0a8efd2e901091bfae5388fc064db9f14f4bda362da0f952be9637ec6790bcdcf9ae3d4bca607259f26c0731e3cbd2882924c9db5653a061a8882bde126643739fe5f0acc5d234467718c27217f56513fd222009802336a061dbaa68a4290e8cce57166ffc6fd22d081c5893a081082b23668ef6c7d65c81a0ef2e0aea160700e14be7285c8b83535f4d104a74ac8db6c188d84ee48a8a647ca0c00853c7500db3c616d5d7dcd7503c02307045e7670a0749ffdebadc732a9ab4a068050da8f891b57fbeacffe4ba3e41f11c5d6b0ec8553fbb796f46951ecd1445a0762e36c38c548c5ae61da51205ef1dc66390702397becef53c50d969cae7a2ada0abff9de80f8e14979ebbe80ae3e702e61b31b91ea481c0e63a7bde12e866eeb5a017220448de88495fdf81446233768ef9441058e4602ecafc1da85a7cbbf1c16da084351381e6cad5052c82f731e8d19d86193794eccdf274529bed7e67309cca78a0784e83133c0ba8ff0262d0c96dc93f936d97eac46327d32f3c1baceb63934d9d80",
    ////"0xf90211a0679ec41f2230e1f57eededf17732966880d9835d744ad769a1b246829341a588a09c2941acea1f1461a7d0af3bb9917c16e3a3339556623a6cad6d1f40ee8fc8a8a0211b79624826f8cd651f7a0123356cfef56854adf7285163988ba4eee0e8f964a062a3e341692078b717029cd105b462749386aecc1cb647721cc382872eac4a51a01a9fc7658bcc2948e1123273e83fb66894e64c2e19aa8f3ac546c45ef4b22290a08c5cdf2e341821e9c3163ec52847e33884f4797669607a60a8adafd00edead0ea08b07046b12762a58e03a482d597cca869aaffd85214bbd08c4624325a7cf80c9a0602d16a56550182218f642f56e66b1cf72555c38dac0fd061b8ef113d4653f4aa038fa2d962cfe43eb49f5a7d1787a436e8e3c6858665b1b0703c4e42ad43f962ea03a706c9b0e0757079f96d9df003eae31aafcf7525d6114033ee929c78adc580aa0f8a66bdc97088d4c73429b9ee00d7bcd0589be3462a53e9f5b9876d4b5231e40a04bbcbff81f2c0b65f29724ef71f6d439b6f857ad5fa7b643c1ea5dfc72ee240fa098cd5bf5aea320986616ff7bfc78efdf43091610fb457447058958e68a13e49ba02033016a2ef0512c926211fbec6f9b7398c58ae10116901d086905979649d968a07cf13191df973971dd4592a95c33cc3c248a4e919b8866c7c8ecff44a6e453a2a017010b7ff49cf72fbc13136f189457a2bc09e8c400ca9cb7997ff75bf34637ec80",
    ////"0xf90211a06c86eef3a8754d952a265132ed86282d34ec24f9f5aa2f085629155798975c2ba02cef7b79076bddfe220fd88ca1a18414683b2f37e8b94cf8c6bdf743cff9d18ca00fe6e40f33bc1b76e34a6c92cdfce9b08f808bca7c6fe85348a7b7e838632a20a0f2f4d7b6fb649794a45288bfbc32274f3031ebc8bbf808146a3104ea27d72e7aa0cf2a353bb32b3b9c004c7586d6723ea5e2ccb99972c84b4b2c90166ca0c3c65ba0753fee595b7a0b80d3574db4e4615a599da7bedfa71bcb9ba214192c6dfb8a4fa0a7e45064974417eeef5556e4fa3533c819cc04825a33f0e244440d4d6a42828ca06cb2eaf789a62824a4a2b730bc4b8ee70e3648fbdf6cd61ea86d234dda67ccc3a0e42e79aeed163de73664c3b4f9451208b22b4874eae6c007b5f0405a64a55050a072f87da9fbd3c727080eef39891888876cdfbc54b732cf4f08ee19d067117d5ba0ce88e695612d636a6f73c2fcc0086e486249a0284cd6b88bf1cc3a7bef84ce9ba0d408599a558fc0ad84aba0bea36e00c1e99ddebf7b74e2f68912563bd5a62522a0154aef7de9275d13e860b11f138a811e6ed97fbf8985c524ccd5c231dbc62180a0282022799ec74b1dc2df4edad584b0b974113a06a857ff72ed17471908d28404a00c4fc7a3f7ded56f4da7093a875bd7c3a6cb35cc6bdf505cb79aee64708640aca0339829e86f4b7a2d68fe0b4707e32016534cdf8a48070a3921a48bcc0fd4b11c80",
    ////"0xf90211a0b70bd38b197882c9e04dbdbc463bd74887af466e509bb9f61283796000649611a05b7c13208dc2fbd708005d510297a825e6ee16a541a1f7860b5226f39e7d31ada09fea01b1db9afdd63932fc4a335ca3af6824afcba793fab68a6536e4f302fc19a0d73148886a70f18c6a41f65a9d012b8a5198deacf33b0839b494a1338b23cf7ba0e6923675583267b502e2a6ac685651f4bfb54b6cf00cffdf7e603927107eca70a01e2fcb240f26a1d85e908bc77a75628b144f31b0f6d56ddc139cb5a56002420ca021420c0d6ab2d50504f7cad0e4d76109c2c93f2c49c9677863f290c8dc4e3c14a0379fe1bd0b044c94f67f844bd2c7f7abf83ac8049ab234ce301326d79fb7ae0ba0890ea9c4679262b86e65f2895ff9e6e97a0ed06d7beb9b4d3d8c8d3246a06715a04569c16e7ba91a901aec96cd999b89201e192670edaff70d2991edf779de5082a0adaed327e31819a530e941a4eebf0ed8e245b9272947199566e89e4496a6c05ba0c39e54b4ce440fbc36c43baafc9809a80e8cc5649b2f8753b5edbac3b7c043e3a0812541bed009f7cae97ba783dde88aced6e5f21fc80b41e91b9479d35184e45ea0708adda1f1ad89034e35a2fd063420d885713fb7f176960e47eebc0df8e8afc0a0a305e0528d3f6122a460eeffc54ce1c4c67f71f376e8d84a4ed23dfdc2cc4effa02928ce112a3e076214a2b1e25fbfc463411c378c12702506c1479f97ba5bffce80",
    ////"0xf90211a09881800af81281b599a2ae599789501c2561294aeb892905e5f454bdcf79a187a047e8fd36ef03ad0479902154249d5e43071efbf78b4974f2cda490fa42d17ba6a063b7d25d086bdfa18c5beb67e4339f683de15346ef948b01139d8c0e83a96387a0b8662c97a229aa73ab190ab402a7fa2acad9cf66251ad0a44c9070732e298b11a0fac6584c1fa6aa7db2e615e10ba63a9b353f3febbe93d3ae2276891668aa7fc1a0777e0f4f2695a65939c8a191cc32e0bc74c557d057a46b5135f36e3c232b7fb8a0d78ec39c3544f76d77c0aa20b4cdb58c8ac29745713b240b7fdd3836497fdb04a04729097a95f6c001478b2ed057c71a9de89b0e4ee18cbf6c04d578bac2c7ed28a09f6f37e1ffed0554f4133b5743e4e7e807054ce7f9615df1fdcceb0264e31829a0cddde78e2ed07fd82b486cca326ec315f3d1df4a635f1898811b1d4d45d7361ca018f06484f8a256a810fdf6800d30c40094de7561a12b3cc9a9e90979e0ce4a10a08c01dbe66e1e60f5edea0e1bf2990aed610dadb9783f2070b206c88ffc05e7ffa09763ea84f4ae07ffec150a3d59674a49c944dc94409881b0380a3ed2e4ab6b70a0d0e86e1c6f991a9afb97bf1648487fcc90f61d4a6f7d8fa419cb829e11c5b764a042d00184633bd8df55db881b1b46457f1d0cff162c8843f9aea18509271f9407a081aad7099cafddcb44141737b986eec45e93aa16774c7d0480d395fca582cf8d80",
    ////"0xf9019180a08eeac7bec8ceaaf659b328d4a04e418159914c7681f83470cd313d6e984a0754a06dac15ddea9fe0ba3097f94727c1f61cda2219e639c443e52b231ceb71b9c86fa0a6545f791304f8f4dfa8bae7699aff682733b246c6df78b03a955b87e974a330a0f75c6a10796830946f04645d5d11e5b0bcbc40f0cb83cd716440e6ef1d8b3d048080a0646d1cbea060b31a3ddfcb8e802620232a2164a64abc04dba88654667668261ba0c61e9aff13ad27a1d50510f88ff4879db3fd7cef1782982d3cf8702742b2941da0b2a8722ff78f03327b585da064ed79ea1818cff6cc41fe3249368cc04493ca41a001719ecf3a6e924abbdbb6f3de50794df3d9f9f503bfb54bab753e2d9b5c7230a08073f6a9ebd0c84a9dd5b6176d52bc80596eb74c192a7a551b3ae80620facaf7a0290f29ddbba5a789b068535aeda99809053bea7642e0bd7a604a15112b5818cb80a00bf0a7e8a9b0797f99bccaa5655462c00172c769c5bed589c149df04c9d748bfa02c83d167a8b35607906f4639c2442bacde5c67dab80bb2fc74564a32d3a3194380",
    ////"0xf8679e20eb3d3905f6526cb7fbb8ca13df8d9c63efade348e70065aa05f578f315b846f8440180a06968aa4d96a817eb4d24aa4d096d0d841f9c52ed7bbc4ca7d7951bba6fc65571a089b1de4a1e012d6a62b18b6ad184985d57545bf1da0ae1c218f4cea34daf099b"

    let proof = array![
        array![
            0x4eae9ef0a01102f9,
            0x4e88a202defd511e,
            0x7ecc729c8a8a5b28,
            0x344e7113f0eeda7c,
            0xfd33cea075d4bc99,
            0x424cd6505e059770,
            0xd522fb1fe4279075,
            0x94dc0772e63ea0b2,
            0x1748a05609e447b5,
            0x5789a7717b4975bf,
            0x6ef1cb0751d089ff,
            0xadce138fe6f702ad,
            0x7a0a5cddf247d9e,
            0x27ff210ecd1d8451,
            0xe7baca2247aa3039,
            0x67f6e9f4d0094eea,
            0xa02e65418ab67ab5,
            0x83c1eecae28e0047,
            0x902efd8e0a6d019c,
            0x6fc8853aebf9110,
            0x2d36da4b4ff1b94d,
            0x67ec3796be52f9a0,
            0xca4b3daef9dcbc90,
            0xe331076cf2597260,
            0x56dbc9242988d2cb,
            0x12de2b88a861a053,
            0xc5acf0e59f734366,
            0x1772c218774634d2,
            0x80092022fd1365f5,
            0xa468aadb61a03623,
            0xfc6f1657ce8c0e29,
            0xa093581c082dd26f,
            0xc7f68e66232b0881,
            0xea0a2eefa0815cd6,
            0x5c28e74be1000716,
            0x744a104d5f53838b,
            0xe44ed888c1b68dac,
            0x5308c0a07c648a8a,
            0xd7d516c6b30d50c7,
            0x457030023c50d7dc,
            0xbadeff49070a67e7,
            0x568a0b49a2a73dc,
            0xacbe7fb591f8a80d,
            0x5d1cf1413ebae4ff,
            0x6f79bb3f55c80e6b,
            0x76a04514cd1e9546,
            0xe65a8c548cc3362e,
            0x63c61def0512a51d,
            0x3cf5cebe97237090,
            0xa0ada2e7ca69d950,
            0x97148e0fe89dffab,
            0xe602e7e30ae8bb9e,
            0xe6c081a41eb9311b,
            0xb5ee66e812de7b3a,
            0x4988de48042217a0,
            0x8e7633624481df5f,
            0xca2e60e4581044f9,
            0xc1f1bb7c5aa81dfc,
            0xcae681133584a06d,
            0xd1e831f7822c05d5,
            0xf2cdec943719869d,
            0x9c30677eed9b5274,
            0x3c13834e78a078ca,
            0x6dc9d06202ffa80b,
            0x63c4ea976d933fc9,
            0x63ebac1b3c2fd327,
            0x809d4d93,
        ]
            .span(),
        array![
            0x1fc49e67a01102f9,
            0xf1eded7ef5e13022,
            0x5d83d98068963277,
            0x8246b2a169d74a74,
            0x41299ca088a54193,
            0xafd0a761141feaac,
            0x33a3e3167c91b93b,
            0x1f6dad6c3a625695,
            0x1b21a0a8c88fee40,
            0x1f65cdf826486279,
            0x68f5fe6c3523017a,
            0x8b98635128f7ad54,
            0x62a064f9e8e0eea4,
            0x17b778206941e3a3,
            0x937462b405d19c02,
            0x1c7247b61cccae86,
            0xa0514aac2e8782c3,
            0x4829cc8b65c79f1a,
            0x68b63fe8733212e1,
            0x3a8faa192e4ce694,
            0x9022b2f45ec446c5,
            0x2118342edf5c8ca0,
            0xe34728c53e16c3e9,
            0x7a60697679f48438,
            0xadde0ed0afada860,
            0x76126b04078ba00e,
            0x7c592d483ae0582a,
            0x4b2185fdaf9a86ca,
            0xcfa7254362c408bd,
            0x65a5162d60a0c980,
            0x6ef542f618221850,
            0xda385c5572cfb166,
            0xd413f18e1b06fdc0,
            0x962dfa38a04a3f65,
            0xd1a7f549eb43fe2c,
            0x58683c8e6e437a78,
            0x2ae4c403071b5b66,
            0x6c703aa02e963fd4,
            0xd9969f0757070e9b,
            0xf7fcaa31ae3e00df,
            0x29e93e0314615d52,
            0xa6f8a00a58dc8ac7,
            0x42734c8d0897dc6b,
            0x8905cd7b0de09e9b,
            0x985b9f3ea56234be,
            0x4ba0401e23b5d476,
            0xf2650b2c1ff8bfbc,
            0xb639d4f671ef2497,
            0xc143b6a75fad57f8,
            0xa00f24ee72fc5dea,
            0x9820a3aef55bcd98,
            0xdfef78fc7bff1666,
            0x477445fb10160943,
            0x9be4138ae6588905,
            0x51f02e6a013320a0,
            0x9b6fecfb1162922c,
            0x901601e18ac59873,
            0xd94996970569081d,
            0x97df9131f17ca068,
            0x335ca99245dd7139,
            0x889b914e8a243ccc,
            0xe4a644ffecc8c766,
            0xf47f0b0117a0a253,
            0x186f1313bc2ff79c,
            0xc4e809bca25794,
            0xf35bf77f99b79cca,
            0x80ec3746,
        ]
            .span(),
        array![
            0xf3ee866ca01102f9,
            0x3251262a954d75a8,
            0xf924ec342d2886ed,
            0x57152956082faaf5,
            0x7bef2ca02b5c9798,
            0xd80f22fedd6b0779,
            0x2f3b681484a1a18c,
            0xf7bdc6f84cb9e837,
            0xe60fa08cd1f9cf43,
            0x4ae3761bbc330fe4,
            0x808fb0e9fccd926c,
            0xa74853e86f7cca8b,
            0xf2a0202a6338e8b7,
            0xa4949764fbb6d7f4,
            0x304f2732bcbf8852,
            0x6a1408f8bbc8eb31,
            0xa07a2ed727ea0431,
            0x9c3b2bb33b352acf,
            0xa53e72d686754c00,
            0x4b4bc87299b9cce2,
            0x5bc6c3a06c16902c,
            0xb7a5b59ee3f75a0,
            0x5a61e4b44d57d380,
            0xcb1ba7dfbea79d59,
            0x8afb6d2c1914a29b,
            0x44976450e4a7a04f,
            0x35fae45655efee17,
            0x335a8204cc19c833,
            0x426a4d0d4444e2f0,
            0x89f7eab26ca08c82,
            0xbc30b7a2a42428a6,
            0xdffb48360ee78e4b,
            0xda4d236da81ed66c,
            0xae792ee4a0c3cc67,
            0xb4c36436e73d16ed,
            0x74482bb2081245f9,
            0x5a40f0b507c0e6ea,
            0x7df872a05050a564,
            0xef0e0827c7d3fba9,
            0xbcdf6c8788188939,
            0x19ee084fcf32b754,
            0x88cea05b7d1167d0,
            0x736f6a632d6195e6,
            0x4962486e08c0fcc2,
            0xccf18bb8d64c28a0,
            0xd4a09bce84ef7b3a,
            0x84adc08f559a5908,
            0xe9c1006ea3bea0ab,
            0x89f6e2747bbfde9d,
            0xa02225a6d53b5612,
            0x135d27e97def4a15,
            0x1e818a131fb160e8,
            0x24c58589bf7fd96e,
            0x8021c6db31c2d5cc,
            0x4bc79e79222028a0,
            0xb084d5da4edfc21d,
            0xff57a8063a1174b9,
            0x84d208194717ed72,
            0xdef7a3c74f0ca004,
            0x5b873a09a74d6fd5,
            0xdf6bcc35cba6c3d7,
            0x867064ee9ab75c50,
            0x6fe8299833a0ac40,
            0x7470bfe682d7a4b,
            0x488adf4c531620e3,
            0xfcc8ba421390a07,
            0x801cb1d4,
        ]
            .span(),
        array![
            0x8bd30bb7a01102f9,
            0xbcbd4de0c9827819,
            0x6e46af8748d73b46,
            0x60798312f6b99b50,
            0x137c5ba011966400,
            0x5d0008d7fbc28d20,
            0x16eee625a8970251,
            0x26520b86f7a141a5,
            0xea9fa0ad317d9ef3,
            0x3239d6fd9adbb101,
            0x2468afa35c334afc,
            0x658ab6fa93a7cbaf,
            0xd7a019fc02f3e436,
            0x6a8cf1706a884831,
            0x518a2b019d5af641,
            0xb439083bf3acde98,
            0xa07bcf238b33a194,
            0xb5673258753692e6,
            0xf4515668aca6e202,
            0xdfff0cf06c4bb5bf,
            0x70ca7e102739607e,
            0xa1260f24cb2f1ea0,
            0x62757ac78b905ed8,
            0x6dd5f6b0314f148b,
            0x420260a5b59c13dc,
            0xb26a0d0c4221a00c,
            0xd7e4d0caf70405d5,
            0xc9492c3fc9c20961,
            0x4edcc890f2637867,
            0xbbde19f37a0143c,
            0xd24b847ff6944c04,
            0x9a04c83af8abf7c7,
            0x9fd7261330ce34b2,
            0xc4a90e89a00baeb7,
            0x89f2656eb8629267,
            0x6dd00e7ae9e6f95f,
            0x328d8c3d4d9beb7b,
            0xc16945a01567a046,
            0x96ec1a901aa97b6e,
            0x26191e20899b99cd,
            0xed91290df7afed70,
            0xaeada08250de79f7,
            0xe930a51918e327d3,
            0x45e2d80ebfeea441,
            0xe8669519472927b9,
            0xc3a05bc0a696449e,
            0x36bc0f44ceb4549e,
            0xea80998fcaa3bc4,
            0xb553872f9b64c58c,
            0xa0e343c0b7c3baed,
            0xcaf709d0be412581,
            0xce8ae8dd83a77be9,
            0xe9410bc81ff2e5d6,
            0x5ee48451d379941b,
            0x89adf1a1dd8a70a0,
            0x203406fda2354e03,
            0x9676f1b73f7185d8,
            0xafe8f80dbcee470e,
            0x3f8d52e005a3a0c0,
            0x4cc5ffee60a42261,
            0xe876f3717fc6c4e1,
            0xccc2fd3dd24e4ad8,
            0x2a11ce2829a0ff4e,
            0x5fe2b1a21462073e,
            0x128c371c4163c4bf,
            0xba979f47c1062570,
            0x80ceff5b,
        ]
            .span(),
        array![
            0xa808198a01102f9,
            0x59aea299b58112f8,
            0x4a2961251c508997,
            0xbd54f4e5052989eb,
            0xfde847a087a179cf,
            0x21907904ad03ef36,
            0xfb1e07435e9d2454,
            0x90a4cdf274498bf7,
            0xb763a0a67bd142fa,
            0x5b8ca1df6b085dd2,
            0xe13d689f33e467eb,
            0x9d13018b94ef4653,
            0xb8a08763a9830e8c,
            0xab73aa29a2972c66,
            0xca2afaa702b40a19,
            0x4ca4d01a2566cfd9,
            0xa0118b292e737090,
            0x7daaa61f4c58c6fa,
            0x9b3aa60be115e6b2,
            0xaed393beeb3f3f35,
            0xc17faa6816897622,
            0xa695264f0f7e77a0,
            0xe032cc91a1c83959,
            0x6ba457d057c574bc,
            0x7f2b233c6ef33551,
            0x44359cc38ed7a0b8,
            0xcdb420aac0776df7,
            0x3b714597c28a8cb5,
            0x7f493638dd7f0b24,
            0x957a092947a004db,
            0x57d02e8b4701c0f6,
            0xe14e0e9be89d1ac7,
            0xc2ba78d5046cbf8c,
            0xe1376f9fa028edc7,
            0x573b13f45405edff,
            0xe74c0507e8e7e443,
            0x2ebccfdf15d61f9,
            0xe7ddcda02918e364,
            0x6c482bd87fd02e8e,
            0xdfd1f315c36e32ca,
            0x1d1b8198185f634a,
            0xf018a01c36d7454d,
            0xfd10a856a2f88464,
            0xde9400c4300d80f6,
            0xe9a9c93c2ba16175,
            0x8ca0104acee07909,
            0xedf5601e6ee6db01,
            0x61ed0a99f21b0eea,
            0xb270203f78b9ad0d,
            0xa0ffe705fc8fc806,
            0xff07aef484ea6397,
            0x494a67593d0a15ec,
            0xb081984094dc44c9,
            0x706babe4d23e0a38,
            0x1a996f1c6ee8d0a0,
            0x7f484816bf97fb9a,
            0x8f7d6f4a1df690cc,
            0xb7c5119e82cb19a4,
            0x3b638401d042a064,
            0x461b1b88db55dfd8,
            0x882c16ff0c1d7f45,
            0x1f270985a1aef943,
            0x9c09d7aa81a00794,
            0xb937171444cbddaf,
            0x7716aa935ec4ee86,
            0xa5fc95d380047d4c,
            0x808dcf82,
        ]
            .span(),
        array![
            0xc7ea8ea0809101f9,
            0x28b359f6aacec8be,
            0x4c915981414ea0d4,
            0x3d31cd7034f88176,
            0xac6da054074a986e,
            0x9730bae09feadd15,
            0x22da1cf6c12747f9,
            0x232be543c439e619,
            0xa6a06fc8b971eb1c,
            0xdff4f80413795f54,
            0x2768ff9a69e7baa8,
            0x3ab078dfc646b233,
            0xa030a374e9875b95,
            0x94306879106a5cf7,
            0xb0e5115d5d64046f,
            0x71cd83cbf040bcbc,
            0x43d8b1defe64064,
            0xa0be1c6d64a08080,
            0x808ecbdf3d1ab360,
            0x4aa664212a232026,
            0x76665486a8db04bc,
            0xff9a1ec6a01b2668,
            0xf81005d5a127ad13,
            0xef7cfdb39d87f48f,
            0x2770f83c2d988217,
            0x72a8b2a01d94b242,
            0x5d587b32038ff72f,
            0xcf1818ea79ed64a0,
            0x8c364932fe41ccf6,
            0x7101a041ca9344c0,
            0xdbbb4a926e3acf9e,
            0xd9f34d7950def3b6,
            0x75ab4bb5bf03f5f9,
            0x80a030725c9b2d3e,
            0x9d4ac8d0eba9f673,
            0x5980bc526d17b6d5,
            0x1b557a2a194cb76e,
            0xa0f7cafa2006e83a,
            0x89a7a5bbdd290f29,
            0x998a9ed5a5368b0,
            0x7abde04276ea3b05,
            0xcb18582b11154a60,
            0xb0a9e8a7f00ba080,
            0x5465a5cabc997f79,
            0xbec569c77201c062,
            0xd7c904df49c189d5,
            0xa867d1832ca0bf48,
            0xc239466f900756b3,
            0xb8da675cdeac2b44,
            0xd3324a5674fcb20b,
            0x804319a3,
        ]
            .span(),
        array![
            0x5393deb209e67f8,
            0x13cab8fbb76c52f6,
            0x48e3adef639c8ddf,
            0xf378f505aa6500e7,
            0xa0800144f846b815,
            0xeb17a8964daa6869,
            0x840d6d094daa244d,
            0xa74cbc7bed529c1f,
            0x7155c66fba1b95d7,
            0x2d011e4adeb189a0,
            0x9884d16a8bb1626a,
            0xe10adaf15b54575d,
            0x9af4da3cef418c2,
            0x9b,
        ]
            .span()
    ];

    let expected_res = array![
        0xaa6869a0800144f8,
        0xaa244deb17a8964d,
        0x529c1f840d6d094d,
        0x1b95d7a74cbc7bed,
        0xb189a07155c66fba,
        0xb1626a2d011e4ade,
        0x54575d9884d16a8b,
        0xf418c2e10adaf15b,
        0x9b09af4da3ce,
    ];

    let key = 0x6464aaeb3d3905f6526cb7fbb8ca13df8d9c63efade348e70065aa05f578f315;

    let mpt = MPTTrait::new(0x2BBF8BB05C4F3446F14BEBAD306B4D0FDD7A53CE5D373A5A8729F0679E18B5C2);
    let res = mpt.verify(key, 64, proof.span()).unwrap();
    assert(res == expected_res.span(), 'Result not matching');
}
