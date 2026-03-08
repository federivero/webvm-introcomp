<script>
	import { createEventDispatcher } from 'svelte';
	import { diskLatency } from './activities.js'	
</script>
<h1 class="text-lg font-bold">Disk</h1>
<p><span class="font-bold">Backend latency: </span>{$diskLatency}ms</p>
