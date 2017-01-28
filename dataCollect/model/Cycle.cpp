/* Copyright (c) 2017, EPL-Vizards
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *     * Redistributions of source code must retain the above copyright
 *       notice, this list of conditions and the following disclaimer.
 *     * Redistributions in binary form must reproduce the above copyright
 *       notice, this list of conditions and the following disclaimer in the
 *       documentation and/or other materials provided with the distribution.
 *     * Neither the name of the EPL-Vizards nor the
 *       names of its contributors may be used to endorse or promote products
 *       derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL EPL-Vizards BE LIABLE FOR ANY
 * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 * (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 * LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 * SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
/*!
 * \file Cycle.cpp
 * \brief Contains class Cycle
 */

#include "Cycle.hpp"

namespace EPL_DataCollect {

/*!
 * \brief Returns the number of nodes
 * \return The amount of nodes as an unsigned char
 */
uint8_t Cycle::getNumNodes() const noexcept { return nodeCount; }


/*!
 * \brief Returns all events active in the cycle
 * \return The currently active events as an std::vector<EventBase*>
 */
std::vector<EventBase *> Cycle::getActiveEvents() const noexcept { return events; }


/*!
 * \brief Returns all packets in the cycle
 * \return The packets currently in the cycle as an std::vector<Packet>
 */
std::vector<Packet> Cycle::getPackets() const noexcept { return packets; }


/*!
 * \brief Returns the cycle number of this Cycle
 * \return The current cycle number as an unsigned int
 */
uint32_t Cycle::getCycleNum() const noexcept { return cycleNum; }


/*!
 * \brief Returns the specified node
 * \param  node The ID / index of the node
 * \throws std::out_of_range if no node with the given ID exists
 * \return The node given by the ID as type Node
 */
Node Cycle::getNode(uint8_t node) { return nodes.at(node); }


/*!
 * \brief Returns a pointer to the cycle storage corresponding to the ID
 * \note Returns nullptr on error
 * \return The pointer to the cycle storage as a CycleStorageBase*
 * \param  id The ID of the storage
 */
CycleStorageBase *Cycle::getCycleStorage(std::string id) noexcept {
  try {
    return cycleStorages.at(id);
  } catch (const std::out_of_range &ex) { return nullptr; }
}


/*!
   * \brief Updates the packet list and increases the cycle counter.
   * This will clear the old packet list and increment the cycle counter by one.
   * \note This function will NOT change the OD entries!
   *
   * C++: friend class CycleBuilder
   * \param  newPackets The packets to apply
   */
void Cycle::updatePackets(std::vector<Packet> newPackets) {
  packets = newPackets;
  cycleNum++;
}
}
