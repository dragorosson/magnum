..
   This work is licensed under a Creative Commons Attribution 3.0 Unported
 License.

 http://creativecommons.org/licenses/by/3.0/legalcode

====================================
Individual Management of Node Groups
====================================

Launchpad blueprint:

https://blueprints.launchpad.net/magnum/+spec/nodegroups

Heterogeneous container clusters enable interesting use-cases that are
impossible on clusters where all nodes are configured the same. For example,
workloads that require differing amounts of memory, I/O, or processing power
can be placed on the nodes that best fit them.


Problem description
===================

Magnum currently only supports creating uniform clusters. Bays (+BayModels) are
monolithic resources with an mix of attributes that are either relevant to the
cluster as a whole, the master nodes, or the worker nodes. To enable
heterogeneous clusters, Bays must be split into multiple resources that
represent the different parts of a cluster.

Use cases
---------

1. Heterogeneous clusters. Users will be able to create clusters that have
   multiple node configurations in them. Containers can be deployed to the node
   type that best fits them.

2. Clusters with nodes in multiple availability zones.

3. Composability. Breaking Bays into components that can work together allows
   them to be combined in more interesting and powerful ways. Each one can then
   be managed by users individually, giving them greater control.

4. Maintainability. As more complex use-cases for Magnum emerge, having
   components that better represent the cluster that Magnum creates will make
   it easier to add features because it will be clear what each one should be
   responsible for.


Proposed change
===============

1. Split Bays(+BayModels) into two resource types: Cluster and NodeGroup.

   .. TODO Add information about how Heat stacks are handled for Clusters and
      NodeGroups

   **Cluster**

   Represents the cluster as a whole and acts as a "parent" for NodeGroups. It
   holds attributes that define the cluster and do not belong to a NodeGroup,
   such as networking information and what bay driver to use.

   Clusters can have zero or more NodeGroups.

   .. TODO Fill in attributes

   **NodeGroup**

   Represents a group of nodes that all have the same configuration. NodeGroups
   must always belong to a single cluster, and a cluster can have multiple
   NodeGroups. NodeGroups hold attributes that characterize the group of nodes,
   such as node count, and those which define the configuration of a node, such
   as flavor, image, and Docker volume size.

   .. TODO Fill in attributes

2. Add ClusterTemplate (CT) and NodeGroupTemplate (NGT)

   .. TODO Flesh out the workings of these resources

   .. TODO Add details about marking attributes immutable

   These two resources serve the same purpose as BayModels: to specify
   some attributes ahead of time so that they do not need to all be specified
   when the cluster is actually created. Like BayModels, CTs and NGTs are not
   backed by any physical resources. However, unlike the relationship between
   BayModels and Bays, CTs and NGTs have all the attributes that ``Cluster``
   and ``NodeGroup``, respectively, do. This makes it so that an entire cluster
   can be created just by specifying the proper ClusterTemplate to use.

   .. TODO Maybe work the following into the above paragraph

   Some notes:

   - NodeGroupTemplates do not need to be a part of a ClusterTemplate.

   - ClusterTemplates can still have (multiple) NodeGroupTemplates added to
     them.

   - Not all attributes need to be defined. Required attributes left
     unspecified still be need to be defined during cluster operations (see
     below).

3. Add API operations for working with Cluster, NodeGroup, ClusterTemplate, and
   NodeGroupTemplate

   .. TODO Needs organization

   .. TODO Add other CRUD operations

   **Cluster creation**

   Clusters can be created in four ways:

   1. Specifying all attributes needed to create a cluster

      It is not necessary to rely on a ClusterTemplate to create a cluster.
      Instead, all attributes can be sent directly in the request. NodeGroups
      can be added directly in the same request as well.

   2. From a ClusterTemplate

      If a ClusterTemplate has its attributes sufficiently defined, nothing
      else is required besides specifying it in the request.

      The created cluster holds no reference to the ClusterTemplate that it was
      created from. This allows the original CT to be freely deleted or
      updated.

   3. From another Cluster

      Specifying another Cluster as the "template" will effectively clone the
      Cluster's configuration for the new cluster being created.

      Similar to creating a cluster from a CT, the created cluster holds no
      reference to the Cluster that it was created from. This allows the
      original Cluster to be freely deleted or updated.

   4. From a Cluster/ClusterTemplate and specifying attributes

      Attributes can be specified along with a reference to a Cluster/CT. The
      attributes specified directly in the request will take priority over the
      ones in the Cluster/CT. NodeGroups can be added in the same request via
      attributes and/or referencing NodeGroups/NGTs as well.

   **Cluster reading**

   .. TODO

   **Cluster updating**

   .. TODO

   **Cluster deleting**

   .. TODO

   **ClusterTemplate operations**

   CRUD operations are valid for ClusterTemplates and work much the same way as
   they do for Clusters. ClusterTemplates can be created from other
   CTs and from existing Clusters too. Any NodeGroups from an existing Cluster
   will be NodeGroupTemplates on the created CT.

   **NodeGroup operations**

   A parent Cluster must be specified when creating a NodeGroup. Otherwise, the
   methods of creating a NodeGroup are the same as creating a Cluster.

   **NodeGroupTemplate operations**

   CRUD operations are valid for NodeGroupTemplates and work much the same way
   as they do for NodeGroups, except that specifying a ClusterTemplate when
   creating a NGT is optional. NodeGroupTemplates can be created from other
   NGTs and from existing NodeGroups too.


Design Principles
-----------------

.. TODO


Alternatives
------------

.. TODO


Data model impact
-----------------

.. TODO


REST API impact
---------------

.. TODO


Security impact
---------------

.. TODO


Notifications impact
--------------------

.. TODO


Other end user impact
---------------------

.. TODO


Performance Impact
------------------

.. TODO


Other deployer impact
---------------------

.. TODO


Developer impact
----------------

.. TODO


Implementation
==============

Assignee(s)
-----------

.. TODO


Work Items
----------

.. TODO


Dependencies
============

.. TODO


Testing
=======

.. TODO


Documentation Impact
====================

.. TODO


References
==========

.. TODO
