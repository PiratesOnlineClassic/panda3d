#define OTHER_LIBS interrogatedb:c dconfig:c dtoolconfig:m \
                   dtoolutil:c dtoolbase:c dtool:m

#begin lib_target
  #define TARGET graph
  #define LOCAL_LIBS \
    putil mathutil

  #define SOURCES \  
    allAttributesWrapper.I allAttributesWrapper.T  \
    allAttributesWrapper.cxx allAttributesWrapper.h \
    allTransitionsWrapper.I allTransitionsWrapper.T \
    allTransitionsWrapper.cxx allTransitionsWrapper.h arcChain.I \
    arcChain.cxx arcChain.h bitMask32Transition.cxx \
    bitMask32Transition.h bitMaskAttribute.T bitMaskAttribute.h \
    bitMaskTransition.T bitMaskTransition.h boundedObject.I \
    boundedObject.N boundedObject.cxx boundedObject.h config_graph.cxx \
    config_graph.h dftraverser.T dftraverser.h \
    graphHashGenerator.h graphReducer.cxx \
    graphReducer.h immediateAttribute.cxx immediateAttribute.h \
    immediateTransition.I immediateTransition.cxx \
    immediateTransition.h lmatrix4fTransition.cxx \
    lmatrix4fTransition.h matrixAttribute.T matrixAttribute.h \
    matrixTransition.T matrixTransition.h multiAttribute.T \
    multiAttribute.h multiNodeAttribute.cxx multiNodeAttribute.h \
    multiNodeTransition.cxx multiNodeTransition.h multiTransition.T \
    multiTransition.h multiTransitionHelpers.I \
    multiTransitionHelpers.h namedNode.I namedNode.cxx namedNode.h \
    node.I node.cxx node.h nodeAttribute.I nodeAttribute.N \
    nodeAttribute.cxx nodeAttribute.h nodeAttributeWrapper.I \
    nodeAttributeWrapper.T nodeAttributeWrapper.cxx \
    nodeAttributeWrapper.h nodeAttributes.I nodeAttributes.N \
    nodeAttributes.T nodeAttributes.cxx nodeAttributes.h \
    nodeConnection.I nodeConnection.cxx nodeConnection.h \
    nodeRelation.I nodeRelation.N nodeRelation.T nodeRelation.cxx \
    nodeRelation.h nodeTransition.I nodeTransition.N \
    nodeTransition.cxx nodeTransition.h nodeTransitionCache.I \
    nodeTransitionCache.cxx nodeTransitionCache.h \
    nodeTransitionCacheEntry.I nodeTransitionCacheEntry.cxx \
    nodeTransitionCacheEntry.h nodeTransitionWrapper.I \
    nodeTransitionWrapper.T nodeTransitionWrapper.cxx \
    nodeTransitionWrapper.h nodeTransitions.I nodeTransitions.T \
    nodeTransitions.cxx nodeTransitions.h nullAttributeWrapper.I \
    nullAttributeWrapper.cxx nullAttributeWrapper.h nullLevelState.cxx \
    nullLevelState.h nullTransitionWrapper.I nullTransitionWrapper.cxx \
    nullTransitionWrapper.h onAttribute.cxx onAttribute.h \
    onOffAttribute.I onOffAttribute.cxx onOffAttribute.h \
    onOffTransition.I onOffTransition.cxx onOffTransition.h \
    onTransition.I onTransition.cxx onTransition.h pointerNameClass.h \
    pt_NamedNode.N pt_NamedNode.cxx pt_NamedNode.h pt_Node.N \
    pt_Node.cxx pt_Node.h \
    pt_NodeRelation.cxx pt_NodeRelation.h \
    setTransitionHelpers.T \
    setTransitionHelpers.h transitionDirection.h traverserVisitor.T \
    traverserVisitor.h \
    vector_PT_Node.cxx vector_PT_Node.h \
    vector_PT_NodeRelation.cxx vector_PT_NodeRelation.h \
    vector_NodeRelation_star.cxx vector_NodeRelation_star.h \
    wrt.I \
    wrt.cxx wrt.h

  #define INSTALL_HEADERS \
    allAttributesWrapper.I allAttributesWrapper.T \
    allAttributesWrapper.h allTransitionsWrapper.I \
    allTransitionsWrapper.T allTransitionsWrapper.h arcChain.I \
    arcChain.h bitMask32Transition.h bitMaskAttribute.T \
    bitMaskAttribute.h bitMaskTransition.T bitMaskTransition.h \
    boundedObject.I boundedObject.h config_graph.h dftraverser.T \
    dftraverser.h graphHashGenerator.h \
    graphReducer.h immediateAttribute.h \
    immediateTransition.I immediateTransition.h lmatrix4fTransition.h \
    matrixAttribute.T matrixAttribute.h matrixTransition.T \
    matrixTransition.h multiAttribute.T multiAttribute.h \
    multiNodeAttribute.h multiNodeTransition.h multiTransition.T \
    multiTransition.h multiTransitionHelpers.I \
    multiTransitionHelpers.h namedNode.I namedNode.h node.I node.h \
    nodeAttribute.I nodeAttribute.h nodeAttributeWrapper.I \
    nodeAttributeWrapper.T nodeAttributeWrapper.h nodeAttributes.I \
    nodeAttributes.T nodeAttributes.h nodeConnection.I \
    nodeConnection.h nodeRelation.I nodeRelation.T nodeRelation.h \
    nodeTransition.I nodeTransition.h nodeTransitionCache.I \
    nodeTransitionCache.h nodeTransitionCacheEntry.I \
    nodeTransitionCacheEntry.h nodeTransitionWrapper.I \
    nodeTransitionWrapper.T nodeTransitionWrapper.h nodeTransitions.I \
    nodeTransitions.T nodeTransitions.h nullAttributeWrapper.I \
    nullAttributeWrapper.h nullLevelState.h nullTransitionWrapper.I \
    nullTransitionWrapper.h onAttribute.h onOffAttribute.I \
    onOffAttribute.h onOffTransition.I onOffTransition.h \
    onTransition.I onTransition.h pointerNameClass.h pt_NamedNode.h \
    pt_Node.h pt_NodeRelation.h \
    setTransitionHelpers.T setTransitionHelpers.h \
    transitionDirection.h traverserVisitor.T traverserVisitor.h \
    vector_PT_Node.h vector_PT_NodeRelation.h vector_NodeRelation_star.h \
    wrt.I wrt.h

  #define IGATESCAN all

#end lib_target

#begin test_bin_target
  #define TARGET test_graph
  #define LOCAL_LIBS \
    graph putil
  #define OTHER_LIBS $[OTHER_LIBS] pystub

  #define SOURCES \
    test_graph.cxx

#end test_bin_target

