use std::{
	pin::Pin,
	task::{Context, Poll},
};

use futures::{Stream, StreamExt};

use crate::{
	bridge_contracts::{BridgeContractCounterparty, BridgeContractInitiator},
	bridge_monitoring::{
		BridgeContractCounterpartyEvent, BridgeContractCounterpartyMonitoring,
		BridgeContractInitiatorEvent, BridgeContractInitiatorMonitoring,
	},
};

#[derive(Debug, PartialEq, Eq)]
pub enum BlockchainEvent<A, H> {
	InitiatorEvent(BridgeContractInitiatorEvent<A, H>),
	CounterpartyEvent(BridgeContractCounterpartyEvent<A, H>),
}

pub trait BlockchainService:
	Stream<Item = BlockchainEvent<Self::Address, Self::Hash>> + Unpin
{
	type Address;
	type Hash;

	type InitiatorContract: BridgeContractInitiator;
	type InitiatorMonitoring: BridgeContractInitiatorMonitoring<Address = Self::Address, Hash = Self::Hash>
		+ Unpin;

	type CounterpartyContract: BridgeContractCounterparty;
	type CounterpartyMonitoring: BridgeContractCounterpartyMonitoring<Address = Self::Address, Hash = Self::Hash>
		+ Unpin;

	fn initiator_contract(&self) -> &Self::InitiatorContract;
	fn initiator_monitoring(&mut self) -> &mut Self::InitiatorMonitoring;
	fn counterparty_contract(&self) -> &Self::CounterpartyContract;
	fn counterparty_monitoring(&mut self) -> &mut Self::CounterpartyMonitoring;

	fn poll_next_event(self: Pin<&mut Self>, cx: &mut Context<'_>) -> Poll<Option<Self::Item>> {
		let this = self.get_mut();

		// let initiator_monitoring = Pin::new(&mut this.initiator_monitoring);
		// let counterparty_monitoring = Pin::new(&mut this.counterparty_monitoring);

		match (
			this.initiator_monitoring().poll_next_unpin(cx),
			this.counterparty_monitoring().poll_next_unpin(cx),
		) {
			(Poll::Ready(Some(event)), _) => {
				Poll::Ready(Some(BlockchainEvent::InitiatorEvent(event)))
			}
			(_, Poll::Ready(Some(event))) => {
				Poll::Ready(Some(BlockchainEvent::CounterpartyEvent(event)))
			}
			_ => Poll::Pending,
		}
	}
}
