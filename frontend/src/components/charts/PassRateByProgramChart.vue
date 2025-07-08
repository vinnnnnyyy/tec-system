<template>
  <div class="h-64">
    <canvas :id="canvasId" class="w-full h-full"></canvas>
  </div>
</template>

<script>
import { onMounted, onUnmounted, ref, watch, nextTick } from 'vue'
import {
  Chart as ChartJS,
  CategoryScale,
  LinearScale,
  BarElement,
  BarController,
  Title,
  Tooltip,
  Legend,
} from 'chart.js'

// Register Chart.js components
ChartJS.register(
  CategoryScale,
  LinearScale,
  BarElement,
  BarController,
  Title,
  Tooltip,
  Legend
)

export default {
  name: 'PassRateByProgramChart',
  props: {
    data: {
      type: Array,
      default: () => []
    },
    canvasId: {
      type: String,
      default: 'pass-rate-program-chart'
    }
  },
  setup(props) {
    const chart = ref(null)
    
    const createChart = async () => {
      // Wait for next tick to ensure DOM is ready
      await nextTick()
      
      const canvasElement = document.getElementById(props.canvasId)
      if (!canvasElement) {
        console.log('Canvas element not found:', props.canvasId)
        return false
      }
      
      // Destroy existing chart if it exists
      if (chart.value) {
        try {
          chart.value.destroy()
        } catch (error) {
          console.warn('Error destroying existing chart:', error)
        }
        chart.value = null
      }
      
      // Check if we have data
      if (!props.data || props.data.length === 0) {
        console.log('No data available for pass rate by program chart')
        return false
      }
      
      // Check if canvas context is available
      const ctx = canvasElement.getContext('2d')
      if (!ctx) {
        console.warn('Canvas context not available for:', props.canvasId)
        return false
      }
      
      // Clear any existing content
      ctx.clearRect(0, 0, canvasElement.width, canvasElement.height)
      
      // Prepare data
      const programs = props.data.map(item => item.program)
      const passRates = props.data.map(item => item.pass_rate)
      
      console.log('Pass rate chart data:', { programs, passRates })
      
      // Generate colors for each bar
      const colors = passRates.map(rate => {
        if (rate >= 80) return 'rgba(34, 197, 94, 0.8)' // Green for high pass rate
        if (rate >= 60) return 'rgba(251, 191, 36, 0.8)' // Yellow for medium pass rate
        return 'rgba(239, 68, 68, 0.8)' // Red for low pass rate
      })
      
      const borderColors = passRates.map(rate => {
        if (rate >= 80) return 'rgba(34, 197, 94, 1)'
        if (rate >= 60) return 'rgba(251, 191, 36, 1)'
        return 'rgba(239, 68, 68, 1)'
      })
      
      try {
        // Create new chart
        chart.value = new ChartJS(ctx, {
          type: 'bar',
          data: {
            labels: programs,
            datasets: [{
              label: 'Pass Rate (%)',
              data: passRates,
              backgroundColor: colors,
              borderColor: borderColors,
              borderWidth: 1,
              borderRadius: 4,
              borderSkipped: false,
            }]
          },
          options: {
            responsive: true,
            maintainAspectRatio: false,
            plugins: {
              legend: {
                display: false
              },
              title: {
                display: false
              },
              tooltip: {
                callbacks: {
                  afterLabel: function(context) {
                    const dataPoint = props.data[context.dataIndex]
                    return `Approved: ${dataPoint.approved} / Total: ${dataPoint.total}`
                  }
                }
              }
            },
            scales: {
              y: {
                beginAtZero: true,
                max: 100,
                ticks: {
                  stepSize: 20,
                  color: '#6B7280',
                  callback: function(value) {
                    return value + '%'
                  }
                },
                grid: {
                  color: '#E5E7EB'
                }
              },
              x: {
                ticks: {
                  color: '#6B7280',
                  maxRotation: 45,
                  minRotation: 0
                },
                grid: {
                  display: false
                }
              }
            }
          }
        })
        
        console.log('Pass rate chart created successfully')
        return true
      } catch (error) {
        console.error('Error creating chart:', error)
        return false
      }
    }
    
    onMounted(async () => {
      // Ensure DOM is fully rendered and Vue has updated
      await nextTick()
      
      console.log('PassRateByProgramChart mounted with data:', props.data)
      
      // Use timeout to ensure DOM is fully rendered and stable
      setTimeout(async () => {
        // Only create chart if we have valid data
        if (props.data && Array.isArray(props.data) && props.data.length > 0) {
          const success = await createChart()
          if (!success) {
            console.log('PassRateByProgramChart: Initial chart creation failed, will retry when data changes')
          }
        } else {
          console.log('PassRateByProgramChart mounted but no data available yet')
        }
      }, 300) // Reduced timeout for better responsiveness
    })
    
    onUnmounted(() => {
      if (chart.value) {
        try {
          chart.value.destroy()
        } catch (error) {
          console.warn('Error destroying chart on unmount:', error)
        }
        chart.value = null
      }
    })
    
    watch(() => props.data, async (newData) => {
      console.log('Pass rate chart data changed:', newData)
      if (newData && Array.isArray(newData) && newData.length > 0) {
        // Add delay to prevent rapid re-creation
        setTimeout(async () => {
          try {
            const success = await createChart()
            if (!success) {
              console.warn('Chart creation failed during data change')
            }
          } catch (error) {
            console.warn('Error recreating chart:', error)
          }
        }, 300)
      } else {
        // If data becomes empty, destroy the chart
        if (chart.value) {
          try {
            chart.value.destroy()
            chart.value = null
          } catch (error) {
            console.warn('Error destroying chart when data cleared:', error)
          }
        }
      }
    }, { deep: true })
    
    return {}
  }
}
</script>
