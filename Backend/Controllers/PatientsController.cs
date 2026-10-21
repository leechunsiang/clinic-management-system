using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ClinicBackend.Data;
using ClinicBackend.Models;

namespace ClinicBackend.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PatientsController : ControllerBase
    {
        private readonly ClinicContext _context;

        public PatientsController(ClinicContext context)
        {
            _context = context;
        }

        // GET: api/patients
        [HttpGet]
        public async Task<ActionResult<IEnumerable<Patient>>> GetPatients()
        {
            return await _context.Patients.ToListAsync();
        }

        // POST: api/patients
        [HttpPost]
        public async Task<ActionResult<Patient>> PostPatient(Patient patient)
        {
            _context.Patients.Add(patient);
            await _context.SaveChangesAsync();

            return CreatedAtAction(nameof(GetPatients), new { id = patient.Id }, patient);
        }
    }
}