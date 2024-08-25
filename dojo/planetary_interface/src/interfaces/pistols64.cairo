use starknet::{ContractAddress, ClassHash, contract_address_const};
use dojo::world::{IWorldDispatcher, IWorldDispatcherTrait, Resource};

use planetary_interface::utils::systems::{get_world_contract_address};
use planetary_interface::interfaces::planetary::{
    PlanetaryInterface, PlanetaryInterfaceTrait,
    IPlanetaryActionsDispatcher, IPlanetaryActionsDispatcherTrait,
};

#[starknet::interface]
trait IPistols64Actions<TState> {
    fn create_challenge(ref self: TState);
    fn reply_challenge(ref self: TState);
    fn commit(ref self: TState);
    fn reveal(ref self: TState);
}

#[derive(Copy, Drop)]
struct Pistols64Interface {
    world: IWorldDispatcher
}

#[generate_trait]
impl Pistols64InterfaceImpl of Pistols64InterfaceTrait {
    
    const NAMESPACE: felt252 = 'pistols64';
    const ACTIONS_SELECTOR: felt252 = selector_from_tag!("pistols64-actions");

    fn new() -> Pistols64Interface {
        let planetary: PlanetaryInterface = PlanetaryInterfaceTrait::new();
        let world_address: ContractAddress = planetary.dispatcher().get_world_address(Self::NAMESPACE);
        (Pistols64Interface{
            world: IWorldDispatcher{contract_address: world_address}
        })
    }

    //
    // dispatchers
    fn dispatcher(self: Pistols64Interface) -> IPistols64ActionsDispatcher {
        (IPistols64ActionsDispatcher{
            contract_address: get_world_contract_address(self.world, Self::ACTIONS_SELECTOR)
        })
    }
}
